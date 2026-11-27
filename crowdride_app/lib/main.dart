import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'appearance_display_page.dart';
import 'crowd_ride_map.dart';
import 'iloilo_places.dart';
import 'iloilo_routes.dart';
import 'logged_out_profile_page.dart';
import 'privacy_page.dart';
import 'profile_page.dart';
import 'route_page.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalAccountStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: appFontLevelNotifier,
      builder: (context, level, _) {
        final scale = appFontScales[level];
        return MaterialApp(
          title: 'CrowdRide',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CrowdRideMapController _mapController = CrowdRideMapController();
  final TextEditingController _searchController = TextEditingController();

  late DateTime _now;
  late Timer _clockTimer;
  List<IloiloPlace> _placeResults = [];
  List<ElptrpRoute> _routeResults = [];
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _mapController.updateTime(_now);

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
        _mapController.updateTime(_now);
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String get _formattedTime =>
      '${_twoDigits(_now.hour)}:${_twoDigits(_now.minute)}';

  String get _formattedDate =>
      '${_twoDigits(_now.month)}/${_twoDigits(_now.day)}';

  String get _trafficPeriodLabel {
    final hourDecimal = _now.hour + (_now.minute / 60.0);
    if (hourDecimal >= 6.5 && hourDecimal <= 9.5) {
      return 'MORNING RUSH HOUR';
    } else if (hourDecimal >= 16.5 && hourDecimal <= 19.5) {
      return 'EVENING RUSH HOUR';
    } else if (hourDecimal >= 11.5 && hourDecimal <= 13.5) {
      return 'MIDDAY MODERATE';
    } else if (hourDecimal >= 21.5 || hourDecimal < 5.5) {
      return 'NIGHT CLEAR FLOW';
    }
    return 'REGULAR DAYTIME FLOW';
  }

  void _onSearchChanged(String query) {
    final trimmed = query.trim().toLowerCase();
    setState(() {
      if (trimmed.isEmpty) {
        _placeResults = [];
        _routeResults = [];
      } else {
        _placeResults = searchIloiloPlaces(query);
        _routeResults = iloiloElptrpRoutes
            .where((r) =>
                r.routeCode.toLowerCase().contains(trimmed) ||
                r.name.toLowerCase().contains(trimmed) ||
                r.corridorSummary.toLowerCase().contains(trimmed))
            .toList();
      }
    });
  }

  void _selectPlace(IloiloPlace place) {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchController.text = place.name;
      _placeResults = [];
      _routeResults = [];
    });
    final targetZoom = place.category == 'District' ? 14.5 : 16.5;
    _mapController.animateTo(place.coordinates, zoom: targetZoom);
  }

  void _selectRoute(ElptrpRoute route) {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchController.text = '${route.routeCode}: ${route.name}';
      _placeResults = [];
      _routeResults = [];
    });
    _mapController.selectRoute(route);
  }

  Future<void> _handleLocateTap() async {
    if (_isLocating) return;

    if (!locationEnabledNotifier.value) {
      _mapController.clearUserLocation();
      _mapController.resetView();
      return;
    }

    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mapController.clearUserLocation();
        _mapController.resetView();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _mapController.clearUserLocation();
        _mapController.resetView();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);

      if (CrowdRideMapController.iloiloCityBounds.contains(currentLatLng)) {
        _mapController.showUserLocation(currentLatLng, zoom: 16.5);
      } else {
        _mapController.clearUserLocation();
        _mapController.resetView();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Current GPS location is outside Iloilo City — centered on Iloilo City.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (_) {
      _mapController.clearUserLocation();
      _mapController.resetView();
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDropdown =
        _placeResults.isNotEmpty || _routeResults.isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. ILOILO CITY 3-LAYER INTERACTIVE MAP
          Positioned.fill(
            child: CrowdRideMap(controller: _mapController),
          ),

          // 2. TOP OVERLAY (Search + Floating Results + Date/Time + Indicator)
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SEARCH BOX
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) {
                          if (_routeResults.isNotEmpty) {
                            _selectRoute(_routeResults.first);
                          } else if (_placeResults.isNotEmpty) {
                            _selectPlace(_placeResults.first);
                          }
                        },
                        decoration: InputDecoration(
                          hintText:
                              'Search ELPTRP route (1-25) or Iloilo landmark...',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : const Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                ),
                        ),
                      ),
                    ),

                    // FLOATING DROPDOWN OVERLAY
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight: hasDropdown ? 240 : 0,
                          ),
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF5EC),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'TIME   $_formattedTime',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'DATE  $_formattedDate',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // 3-LAYER SWITCHER (Plain | Routes | Traffic)
                                  ValueListenableBuilder<CrowdRideMapLayer>(
                                    valueListenable:
                                        _mapController.layerNotifier,
                                    builder: (context, activeLayer, _) {
                                      return Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2B6770),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildLayerChip(
                                              label: 'Plain',
                                              isSelected: activeLayer ==
                                                  CrowdRideMapLayer.plain,
                                              onTap: () =>
                                                  _mapController.setLayer(
                                                      CrowdRideMapLayer.plain),
                                            ),
                                            _buildLayerChip(
                                              label: 'Routes',
                                              isSelected: activeLayer ==
                                                  CrowdRideMapLayer.transport,
                                              onTap: () =>
                                                  _mapController.setLayer(
                                                      CrowdRideMapLayer
                                                          .transport),
                                            ),
                                            _buildLayerChip(
                                              label: 'Traffic',
                                              isSelected: activeLayer ==
                                                  CrowdRideMapLayer.traffic,
                                              onTap: () =>
                                                  _mapController.setLayer(
                                                      CrowdRideMapLayer
                                                          .traffic),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              // Aspect-ratio locked indicator + OSM sync badge
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: Image.asset(
                                      'assets/buttons/indicator.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ValueListenableBuilder<OsmSyncStatus>(
                                    valueListenable:
                                        _mapController.osmSyncStatusNotifier,
                                    builder: (context, syncStatus, _) {
                                      if (syncStatus == OsmSyncStatus.synced) {
                                        return const SizedBox.shrink();
                                      }
                                      final isSyncing =
                                          syncStatus == OsmSyncStatus.syncing;
                                      return GestureDetector(
                                        onTap: isSyncing
                                            ? null
                                            : () => _mapController.syncOsmRoads(
                                                  forceRefresh: true,
                                                ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSyncing
                                                ? const Color(0xFF2B6770)
                                                : const Color(0xFFD50000),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            isSyncing
                                                ? 'Aligning roads...'
                                                : 'Tap to align roads',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (hasDropdown)
                          Positioned(
                            top: 4,
                            left: 0,
                            right: 0,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 230),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  ..._routeResults.map((route) => ListTile(
                                        dense: true,
                                        leading: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: route.color,
                                          child: Text(
                                            '${route.routeNumber}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          '${route.routeCode}: ${route.name}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: Text(
                                          route.corridorSummary,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        onTap: () => _selectRoute(route),
                                      )),
                                  ..._placeResults.map((place) => ListTile(
                                        dense: true,
                                        leading: Icon(
                                          iconForIloiloCategory(place.category),
                                          color: const Color(0xFF2B6770),
                                        ),
                                        title: Text(
                                          place.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${place.category} • ${place.district}, Iloilo City',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        onTap: () => _selectPlace(place),
                                      )),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. BOTTOM CONTROLS WRAPPED IN SAFEAREA (Prevents Android Nav Bar Overlap)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row above bottom bar: Active Route/Traffic Banner + Face North & Zoom Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Left Banner (Traffic Legend or Selected Route)
                          Expanded(
                            child: ValueListenableBuilder<CrowdRideMapLayer>(
                              valueListenable: _mapController.layerNotifier,
                              builder: (context, activeLayer, _) {
                                if (activeLayer == CrowdRideMapLayer.traffic) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B6770)
                                          .withValues(alpha: 0.95),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'TRAFFIC: $_trafficPeriodLabel',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _legendDot(
                                              const Color(0xFF00C853),
                                              'Clear',
                                            ),
                                            const SizedBox(width: 8),
                                            _legendDot(
                                              const Color(0xFFFFD600),
                                              'Mod',
                                            ),
                                            const SizedBox(width: 8),
                                            _legendDot(
                                              const Color(0xFFFF6D00),
                                              'Busy',
                                            ),
                                            const SizedBox(width: 8),
                                            _legendDot(
                                              const Color(0xFFD50000),
                                              'Rush',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (activeLayer ==
                                    CrowdRideMapLayer.transport) {
                                  return ValueListenableBuilder<ElptrpRoute?>(
                                    valueListenable:
                                        _mapController.selectedRouteNotifier,
                                    builder: (context, selectedRoute, _) {
                                      if (selectedRoute == null) {
                                        return const SizedBox.shrink();
                                      }
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: selectedRoute.color,
                                            width: 2,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor:
                                                  selectedRoute.color,
                                              child: Text(
                                                '${selectedRoute.routeNumber}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    selectedRoute.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedRoute
                                                        .corridorSummary,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: _mapController
                                                  .clearSelectedRoute,
                                              child: const Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Right Column: Face North (Compass) + Zoom In + Zoom Out
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder<double>(
                                valueListenable:
                                    _mapController.rotationNotifier,
                                builder: (context, rotationDeg, _) {
                                  return GestureDetector(
                                    onTap: _mapController.resetNorth,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2B6770),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Transform.rotate(
                                        angle:
                                            rotationDeg * (3.14159265 / 180.0),
                                        child: const Icon(
                                          Icons.navigation,
                                          color: Color(0xFFF7941D),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _mapController.zoomBy(1.3),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.asset(
                                    'assets/buttons/zoom_in.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _mapController.zoomBy(0.75),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.asset(
                                    'assets/buttons/zoom_out.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bottom Action Bar (Route | Locate | Profile)
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RoutePage(),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/buttons/route_button.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              isLoggedInNotifier.value
                                                  ? const ProfilePage()
                                                  : const LoggedOutProfilePage(),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/buttons/profile_button.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 14,
                              child: GestureDetector(
                                onTap: _handleLocateTap,
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/buttons/locate_button.png',
                                        fit: BoxFit.contain,
                                      ),
                                      if (_isLocating)
                                        const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF7941D) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}