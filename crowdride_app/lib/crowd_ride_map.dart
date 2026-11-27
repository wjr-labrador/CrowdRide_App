import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'iloilo_routes.dart';

enum CrowdRideMapLayer {
  plain, // Uses local assets/map/map.jpg
  transport, // Online OpenStreetMap + 25 ELPTRP road-matched routes
  traffic, // Online OpenStreetMap + time-reactive traffic heatmap on the same roads
}

enum OsmSyncStatus { syncing, synced, failed }

class CrowdRideMapController {
  final MapController mapController = MapController();

  final TransformationController plainTransformationController =
      TransformationController();
  final GlobalKey _plainViewportKey = GlobalKey();
  final GlobalKey _plainContentKey = GlobalKey();
  Size _cachedPlainContentSize = Size.zero;

  final ValueNotifier<CrowdRideMapLayer> layerNotifier =
      ValueNotifier<CrowdRideMapLayer>(CrowdRideMapLayer.transport);

  final ValueNotifier<ElptrpRoute?> selectedRouteNotifier =
      ValueNotifier<ElptrpRoute?>(null);

  final ValueNotifier<LatLng?> selectedPinNotifier =
      ValueNotifier<LatLng?>(null);

  final ValueNotifier<LatLng?> userLocationNotifier =
      ValueNotifier<LatLng?>(null);

  final ValueNotifier<DateTime> timeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  final ValueNotifier<OsmSyncStatus> osmSyncStatusNotifier =
      ValueNotifier<OsmSyncStatus>(OsmSyncStatus.syncing);

  final ValueNotifier<int> osmSyncRevision = ValueNotifier<int>(0);

  void Function(LatLng target, double zoom)? _animateCallback;

  static const LatLng iloiloCenter = LatLng(10.7145, 122.5550);

  static final LatLngBounds iloiloCityBounds = LatLngBounds(
    const LatLng(10.6750, 122.4900),
    const LatLng(10.7750, 122.6000),
  );

  Size _getPlainViewportSize() {
    final box =
        _plainViewportKey.currentContext?.findRenderObject() as RenderBox?;
    return (box != null && box.hasSize) ? box.size : Size.zero;
  }

  Size _getPlainContentSize() {
    final box =
        _plainContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && box.size != Size.zero) {
      _cachedPlainContentSize = box.size;
    }
    return _cachedPlainContentSize;
  }

  double get plainMinScale {
    final viewport = _getPlainViewportSize();
    final content = _getPlainContentSize();
    if (viewport == Size.zero || content == Size.zero) return 0.2;
    return max(
      viewport.width / content.width,
      viewport.height / content.height,
    ).clamp(0.1, 1.0);
  }

  void setLayer(CrowdRideMapLayer layer) {
    layerNotifier.value = layer;
  }

  void updateTime(DateTime now) {
    if (timeNotifier.value.minute != now.minute ||
        timeNotifier.value.hour != now.hour) {
      timeNotifier.value = now;
    }
  }

  Future<void> syncOsmRoads({bool forceRefresh = false}) async {
    osmSyncStatusNotifier.value = OsmSyncStatus.syncing;
    final ok = await IloiloOsmRoadNetwork.syncFromOverpass(
      forceRefresh: forceRefresh,
    );
    if (ok) {
      osmSyncStatusNotifier.value = OsmSyncStatus.synced;
      osmSyncRevision.value++;
      final selected = selectedRouteNotifier.value;
      if (selected != null) {
        _fitRouteBounds(selected.activeWaypoints);
      }
    } else {
      osmSyncStatusNotifier.value = OsmSyncStatus.failed;
    }
  }

  void selectRoute(ElptrpRoute? route) {
    selectedRouteNotifier.value = route;
    if (route != null) {
      layerNotifier.value = CrowdRideMapLayer.transport;
      _fitRouteBounds(route.activeWaypoints);
    }
  }

  void _fitRouteBounds(List<LatLng> points) {
    if (points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(points);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.fromLTRB(48, 175, 48, 185),
          ),
        );
      } catch (_) {}
    });
  }

  void clearSelectedRoute() {
    selectedRouteNotifier.value = null;
  }

  void zoomBy(double scaleFactor) {
    if (layerNotifier.value == CrowdRideMapLayer.plain) {
      _zoomPlainAsset(scaleFactor);
      return;
    }
    final currentZoom = mapController.camera.zoom;
    final zoomDelta = scaleFactor > 1.0 ? 0.8 : -0.8;
    final nextZoom = (currentZoom + zoomDelta).clamp(12.2, 18.0);
    mapController.move(mapController.camera.center, nextZoom);
  }

  void _zoomPlainAsset(double scaleFactor) {
    final viewport = _getPlainViewportSize();
    final content = _getPlainContentSize();
    if (viewport == Size.zero) return;

    final currentScale =
        plainTransformationController.value.getMaxScaleOnAxis();
    final newScale =
        (currentScale * scaleFactor).clamp(plainMinScale, 5.0);
    if ((newScale - currentScale).abs() < 0.0001) return;

    final screenCenter = Offset(viewport.width / 2.0, viewport.height / 2.0);
    final focalMapPoint = plainTransformationController.toScene(screenCenter);

    double targetTx = screenCenter.dx - (focalMapPoint.dx * newScale);
    double targetTy = screenCenter.dy - (focalMapPoint.dy * newScale);

    if (content != Size.zero) {
      final minTx = min(0.0, viewport.width - (content.width * newScale));
      final minTy = min(0.0, viewport.height - (content.height * newScale));
      targetTx = targetTx.clamp(minTx, 0.0);
      targetTy = targetTy.clamp(minTy, 0.0);
    }

    plainTransformationController.value = Matrix4.identity()
      ..translateByDouble(targetTx, targetTy, 0.0, 1.0)
      ..scaleByDouble(newScale, newScale, 1.0, 1.0);
  }

  void animateTo(LatLng target, {double zoom = 16.2, bool showPin = true}) {
    if (layerNotifier.value == CrowdRideMapLayer.plain && showPin) {
      layerNotifier.value = CrowdRideMapLayer.transport;
    }
    selectedPinNotifier.value = showPin ? target : null;
    if (_animateCallback != null) {
      _animateCallback!(target, zoom);
    } else {
      mapController.move(target, zoom);
    }
  }

  /// Centers the map on the user's current GPS position and shows a blue dot
  void showUserLocation(LatLng position, {double zoom = 16.5}) {
    if (layerNotifier.value == CrowdRideMapLayer.plain) {
      layerNotifier.value = CrowdRideMapLayer.transport;
    }
    userLocationNotifier.value = position;
    selectedPinNotifier.value = null;
    if (_animateCallback != null) {
      _animateCallback!(position, zoom);
    } else {
      mapController.move(position, zoom);
    }
  }

  void clearUserLocation() {
    userLocationNotifier.value = null;
  }

  void resetView() {
    selectedPinNotifier.value = null;
    selectedRouteNotifier.value = null;

    if (layerNotifier.value == CrowdRideMapLayer.plain) {
      final viewport = _getPlainViewportSize();
      final content = _getPlainContentSize();
      final scale = plainMinScale;
      if (viewport != Size.zero && content != Size.zero) {
        final tx = min(0.0, (viewport.width - (content.width * scale)) / 2.0);
        final ty =
            min(0.0, (viewport.height - (content.height * scale)) / 2.0);
        plainTransformationController.value = Matrix4.identity()
          ..translateByDouble(tx, ty, 0.0, 1.0)
          ..scaleByDouble(scale, scale, 1.0, 1.0);
      } else {
        plainTransformationController.value = Matrix4.identity();
      }
      return;
    }

    animateTo(iloiloCenter, zoom: 13.5, showPin: false);
  }

  void dispose() {
    plainTransformationController.dispose();
    layerNotifier.dispose();
    selectedRouteNotifier.dispose();
    selectedPinNotifier.dispose();
    userLocationNotifier.dispose();
    timeNotifier.dispose();
    osmSyncStatusNotifier.dispose();
    osmSyncRevision.dispose();
    mapController.dispose();
  }
}

class CrowdRideMap extends StatefulWidget {
  final CrowdRideMapController? controller;
  final List<Marker> extraMarkers;

  const CrowdRideMap({
    super.key,
    this.controller,
    this.extraMarkers = const [],
  });

  @override
  State<CrowdRideMap> createState() => _CrowdRideMapState();
}

class _CrowdRideMapState extends State<CrowdRideMap>
    with TickerProviderStateMixin {
  late final CrowdRideMapController _controller;
  late final bool _ownsController;
  AnimationController? _panAnimController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CrowdRideMapController();
    _controller._animateCallback = _smoothPanTo;
    _controller.syncOsmRoads();
  }

  void _smoothPanTo(LatLng destLocation, double destZoom) {
    _panAnimController?.dispose();

    final startCenter = _controller.mapController.camera.center;
    final startZoom = _controller.mapController.camera.zoom;

    final latTween = Tween<double>(
      begin: startCenter.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: startCenter.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: startZoom,
      end: destZoom.clamp(12.2, 18.0),
    );

    _panAnimController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: _panAnimController!,
      curve: Curves.easeInOutCubic,
    );

    _panAnimController!.addListener(() {
      _controller.mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    _panAnimController!.forward();
  }

  @override
  void dispose() {
    _panAnimController?.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  List<Polyline> _buildTransportPolylines(ElptrpRoute? selectedRoute) {
    if (selectedRoute == null) {
      return iloiloElptrpRoutes.map((route) {
        return Polyline(
          points: route.activeWaypoints,
          strokeWidth: 8.5,
          useStrokeWidthInMeter: true,
          color: route.color.withValues(alpha: 0.62),
        );
      }).toList();
    }

    final List<Polyline> lines = iloiloElptrpRoutes
        .where((r) => r.routeNumber != selectedRoute.routeNumber)
        .map((route) {
      return Polyline(
        points: route.activeWaypoints,
        strokeWidth: 5.0,
        useStrokeWidthInMeter: true,
        color: Colors.grey.withValues(alpha: 0.16),
      );
    }).toList();

    lines.add(
      Polyline(
        points: selectedRoute.activeWaypoints,
        strokeWidth: 16.0,
        useStrokeWidthInMeter: true,
        color: selectedRoute.color,
        borderStrokeWidth: 2.5,
        borderColor: const Color(0xFF1A252F),
      ),
    );

    return lines;
  }

  List<Polyline> _buildTrafficPolylines(DateTime time) {
    return IloiloOsmRoadNetwork.trafficCorridors.map((segment) {
      final severity = segment.evaluateAt(time);
      final color = TrafficRoadSegment.colorForSeverity(severity);
      return Polyline(
        points: segment.points,
        strokeWidth: 13.0,
        useStrokeWidthInMeter: true,
        color: color.withValues(alpha: 0.85),
      );
    }).toList();
  }

  Widget _buildPlainAssetMap() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller._getPlainContentSize();
    });

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _controller._getPlainContentSize();
            setState(() {});
          }
        });
        return true;
      },
      child: InteractiveViewer(
        key: _controller._plainViewportKey,
        transformationController: _controller.plainTransformationController,
        boundaryMargin: EdgeInsets.zero,
        minScale: _controller.plainMinScale,
        maxScale: 5.0,
        constrained: false,
        clipBehavior: Clip.hardEdge,
        child: SizeChangedLayoutNotifier(
          child: Image.asset(
            'assets/map/map.jpg',
            key: _controller._plainContentKey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CrowdRideMapLayer>(
      valueListenable: _controller.layerNotifier,
      builder: (context, activeLayer, _) {
        if (activeLayer == CrowdRideMapLayer.plain) {
          return _buildPlainAssetMap();
        }

        return FlutterMap(
          mapController: _controller.mapController,
          options: MapOptions(
            initialCenter: CrowdRideMapController.iloiloCenter,
            initialZoom: 13.5,
            minZoom: 12.2,
            maxZoom: 18.0,
            cameraConstraint: CameraConstraint.contain(
              bounds: CrowdRideMapController.iloiloCityBounds,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.crowdride_app',
            ),

            if (activeLayer == CrowdRideMapLayer.traffic)
              ValueListenableBuilder<int>(
                valueListenable: _controller.osmSyncRevision,
                builder: (context, _, __) {
                  return ValueListenableBuilder<DateTime>(
                    valueListenable: _controller.timeNotifier,
                    builder: (context, now, _) {
                      return PolylineLayer(
                        polylines: _buildTrafficPolylines(now),
                      );
                    },
                  );
                },
              )
            else
              ValueListenableBuilder<int>(
                valueListenable: _controller.osmSyncRevision,
                builder: (context, _, __) {
                  return ValueListenableBuilder<ElptrpRoute?>(
                    valueListenable: _controller.selectedRouteNotifier,
                    builder: (context, selectedRoute, _) {
                      return PolylineLayer(
                        polylines: _buildTransportPolylines(selectedRoute),
                      );
                    },
                  );
                },
              ),

            if (activeLayer == CrowdRideMapLayer.transport)
              ValueListenableBuilder<int>(
                valueListenable: _controller.osmSyncRevision,
                builder: (context, _, __) {
                  return ValueListenableBuilder<ElptrpRoute?>(
                    valueListenable: _controller.selectedRouteNotifier,
                    builder: (context, selectedRoute, _) {
                      if (selectedRoute == null ||
                          selectedRoute.activeWaypoints.length < 2) {
                        return const SizedBox.shrink();
                      }
                      return MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedRoute.activeWaypoints.first,
                            width: 64,
                            height: 28,
                            child: _buildEndpointBadge(
                              'START',
                              selectedRoute.color,
                            ),
                          ),
                          Marker(
                            point: selectedRoute.activeWaypoints.last,
                            width: 56,
                            height: 28,
                            child: _buildEndpointBadge('END', Colors.black87),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

            // User's live GPS location dot
            ValueListenableBuilder<LatLng?>(
              valueListenable: _controller.userLocationNotifier,
              builder: (context, userPos, _) {
                if (userPos == null) return const SizedBox.shrink();
                return MarkerLayer(
                  markers: [
                    Marker(
                      point: userPos,
                      width: 34,
                      height: 34,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E88E5).withValues(alpha: 0.25),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E88E5),
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            ValueListenableBuilder<LatLng?>(
              valueListenable: _controller.selectedPinNotifier,
              builder: (context, selectedPin, _) {
                if (selectedPin == null) return const SizedBox.shrink();
                return MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedPin,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_pin,
                        color: Color(0xFFFF0000),
                        size: 44,
                      ),
                    ),
                  ],
                );
              },
            ),

            if (widget.extraMarkers.isNotEmpty)
              MarkerLayer(markers: widget.extraMarkers),
          ],
        );
      },
    );
  }

  Widget _buildEndpointBadge(String label, Color bgColor) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}