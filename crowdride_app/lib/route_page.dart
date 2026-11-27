import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'crowd_ride_map.dart';
import 'iloilo_places.dart';
import 'iloilo_routes.dart';

enum _RoutePagePhase {
  searchList, // Phase 1: From/Destination search + route list
  routePreview, // Phase 2: Route map + coin fare containers + TRACK button
  tracking, // Phase 3: Lowered info panel focusing on map + END button
}

class _RouteMatchResult {
  final ElptrpRoute route;
  final bool isDirectMatch;
  final double nearestDistanceMeters;

  const _RouteMatchResult({
    required this.route,
    required this.isDirectMatch,
    this.nearestDistanceMeters = 0.0,
  });
}

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final CrowdRideMapController _mapController = CrowdRideMapController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _destController = TextEditingController();
  final FocusNode _fromFocus = FocusNode();
  final FocusNode _destFocus = FocusNode();

  _RoutePagePhase _phase = _RoutePagePhase.searchList;
  ElptrpRoute? _selectedRoute;

  IloiloPlace? _selectedFromPlace;
  IloiloPlace? _selectedDestPlace;
  List<IloiloPlace> _activeSuggestions = [];
  bool _editingFromField = true;

  @override
  void initState() {
    super.initState();
    _mapController.setLayer(CrowdRideMapLayer.transport);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _destController.dispose();
    _fromFocus.dispose();
    _destFocus.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onFromChanged(String value) {
    setState(() {
      _editingFromField = true;
      _selectedFromPlace = null;
      _activeSuggestions = searchIloiloPlaces(value);
      if (_phase != _RoutePagePhase.searchList) {
        _phase = _RoutePagePhase.searchList;
      }
    });
  }

  void _onDestChanged(String value) {
    setState(() {
      _editingFromField = false;
      _selectedDestPlace = null;
      _activeSuggestions = searchIloiloPlaces(value);
      if (_phase != _RoutePagePhase.searchList) {
        _phase = _RoutePagePhase.searchList;
      }
    });
  }

  void _pickSuggestion(IloiloPlace place) {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_editingFromField) {
        _fromController.text = place.name;
        _selectedFromPlace = place;
      } else {
        _destController.text = place.name;
        _selectedDestPlace = place;
      }
      _activeSuggestions = [];
      _phase = _RoutePagePhase.searchList;
    });
  }

  IloiloPlace? _resolvePlace(IloiloPlace? explicit, String query) {
    if (explicit != null) return explicit;
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;
    final matches = searchIloiloPlaces(trimmed);
    return matches.isNotEmpty ? matches.first : null;
  }

  bool _routeMatchesText(ElptrpRoute route, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return false;
    return route.routeCode.toLowerCase().contains(q) ||
        route.name.toLowerCase().contains(q) ||
        route.corridorSummary.toLowerCase().contains(q);
  }

  /// Computes matching routes for From & Destination, or nearest route suggestions if off-route
  ({List<_RouteMatchResult> items, bool showingNearestFallback})
      _computeRouteResults() {
    final fromText = _fromController.text.trim();
    final destText = _destController.text.trim();

    // If nothing is entered in either search box, show all 25 ELPTRP routes
    if (fromText.isEmpty && destText.isEmpty) {
      return (
        items: iloiloElptrpRoutes
            .map((r) => _RouteMatchResult(route: r, isDirectMatch: true))
            .toList(),
        showingNearestFallback: false,
      );
    }

    final fromPlace = _resolvePlace(_selectedFromPlace, fromText);
    final destPlace = _resolvePlace(_selectedDestPlace, destText);

    // 380m threshold counts as a route passing directly by that landmark/street
    const double passThresholdMeters = 380.0;

    final List<_RouteMatchResult> directMatches = [];
    final List<_RouteMatchResult> scoredAll = [];

    for (final route in iloiloElptrpRoutes) {
      double fromDist = 0.0;
      double destDist = 0.0;
      bool matchesFrom = true;
      bool matchesDest = true;

      if (fromText.isNotEmpty) {
        if (fromPlace != null) {
          fromDist = route.distanceToPointMeters(fromPlace.coordinates);
          matchesFrom = fromDist <= passThresholdMeters ||
              _routeMatchesText(route, fromText);
        } else {
          matchesFrom = _routeMatchesText(route, fromText);
          fromDist = matchesFrom ? 0.0 : 9999.0;
        }
      }

      if (destText.isNotEmpty) {
        if (destPlace != null) {
          destDist = route.distanceToPointMeters(destPlace.coordinates);
          matchesDest = destDist <= passThresholdMeters ||
              _routeMatchesText(route, destText);
        } else {
          matchesDest = _routeMatchesText(route, destText);
          destDist = matchesDest ? 0.0 : 9999.0;
        }
      }

      final double combinedDist =
          (fromText.isNotEmpty ? fromDist : 0.0) +
          (destText.isNotEmpty ? destDist : 0.0);

      if (matchesFrom && matchesDest) {
        directMatches.add(
          _RouteMatchResult(
            route: route,
            isDirectMatch: true,
            nearestDistanceMeters: combinedDist,
          ),
        );
      }

      scoredAll.add(
        _RouteMatchResult(
          route: route,
          isDirectMatch: false,
          nearestDistanceMeters: combinedDist,
        ),
      );
    }

    if (directMatches.isNotEmpty) {
      directMatches.sort(
        (a, b) => a.nearestDistanceMeters.compareTo(b.nearestDistanceMeters),
      );
      return (items: directMatches, showingNearestFallback: false);
    }

    // Fallback: suggest the nearest routes to the searched From/Destination locations
    scoredAll.sort(
      (a, b) => a.nearestDistanceMeters.compareTo(b.nearestDistanceMeters),
    );
    return (
      items: scoredAll.take(6).toList(),
      showingNearestFallback: true,
    );
  }

  void _selectRouteForPreview(ElptrpRoute route) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedRoute = route;
      _activeSuggestions = [];
      _phase = _RoutePagePhase.routePreview;
    });
    _mapController.selectRoute(route);
  }

  List<Marker> _buildEndpointPinMarkers() {
    final List<Marker> markers = [];
    final fromPlace = _resolvePlace(_selectedFromPlace, _fromController.text);
    final destPlace = _resolvePlace(_selectedDestPlace, _destController.text);

    if (fromPlace != null) {
      markers.add(
        Marker(
          point: fromPlace.coordinates,
          width: 72,
          height: 46,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B6770),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'FROM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.location_pin,
                color: Color(0xFF2B6770),
                size: 28,
              ),
            ],
          ),
        ),
      );
    }

    if (destPlace != null) {
      markers.add(
        Marker(
          point: destPlace.coordinates,
          width: 72,
          height: 46,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7941D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'DEST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.location_pin,
                color: Color(0xFFD50000),
                size: 28,
              ),
            ],
          ),
        ),
      );
    }

    return markers;
  }

  void _handleHeaderBack() {
    if (_phase == _RoutePagePhase.tracking) {
      setState(() => _phase = _RoutePagePhase.routePreview);
    } else if (_phase == _RoutePagePhase.routePreview) {
      setState(() {
        _phase = _RoutePagePhase.searchList;
        _selectedRoute = null;
      });
      _mapController.clearSelectedRoute();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultsData = _computeRouteResults();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. ROUTE HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/route_page/route_header.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 64,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _handleHeaderBack,
                  ),
                ),
              ],
            ),

            // 2. MAIN WORKSPACE (Map background + Search Bars + Phase 1/2/3 Card)
            Expanded(
              child: Stack(
                children: [
                  // Interactive Iloilo City Route Map
                  Positioned.fill(
                    child: CrowdRideMap(
                      controller: _mapController,
                      extraMarkers: _buildEndpointPinMarkers(),
                    ),
                  ),

                  // Soft cream veil in Phase 1 so the search boxes & route list pop cleanly
                  if (_phase == _RoutePagePhase.searchList)
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFFF6F4EE).withValues(alpha: 0.94),
                      ),
                    ),

                  // TOP TWO SEARCH BARS ("From" & "Destination") + Floating Autocomplete
                  Positioned(
                    top: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSearchBox(
                          controller: _fromController,
                          focusNode: _fromFocus,
                          hint: 'From (Your current location or landmark)...',
                          onChanged: _onFromChanged,
                          onClear: () {
                            _fromController.clear();
                            _onFromChanged('');
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildSearchBox(
                          controller: _destController,
                          focusNode: _destFocus,
                          hint: 'Destination (Where are you going?)...',
                          onChanged: _onDestChanged,
                          onClear: () {
                            _destController.clear();
                            _onDestChanged('');
                          },
                        ),

                        // Floating Place Autocomplete Dropdown
                        if (_activeSuggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            constraints: const BoxConstraints(maxHeight: 190),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _activeSuggestions.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final place = _activeSuggestions[index];
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF2B6770),
                                    size: 20,
                                  ),
                                  title: Text(
                                    place.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${place.category} • ${place.district}, Iloilo City',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  onTap: () => _pickSuggestion(place),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  // PHASE 1: ROUTE RESULTS LIST CONTAINER
                  if (_phase == _RoutePagePhase.searchList &&
                      _activeSuggestions.isEmpty)
                    Positioned(
                      top: 126,
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: _buildPhase1RouteList(
                        resultsData.items,
                        resultsData.showingNearestFallback,
                      ),
                    ),

                  // PHASE 3: ZOOM BUTTONS ABOVE LOWERED TRACKING CONTAINER
                  if (_phase == _RoutePagePhase.tracking)
                    Positioned(
                      right: 16,
                      bottom: 152,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _mapController.zoomBy(1.3),
                            child: SizedBox(
                              width: 44,
                              height: 44,
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
                              width: 44,
                              height: 44,
                              child: Image.asset(
                                'assets/buttons/zoom_out.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // PHASE 2 & PHASE 3: BOTTOM TEAL ROUTE INFO & FARE SHEET
                  if ((_phase == _RoutePagePhase.routePreview ||
                          _phase == _RoutePagePhase.tracking) &&
                      _selectedRoute != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _phase == _RoutePagePhase.routePreview
                          ? _buildPhase2PreviewSheet(_selectedRoute!)
                          : _buildPhase3TrackingSheet(_selectedRoute!),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required ValueChanged<String> onChanged,
    required VoidCallback onClear,
  }) {
    return Container(
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
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                  onPressed: onClear,
                )
              : const Icon(Icons.search, color: Colors.black54, size: 22),
        ),
      ),
    );
  }

  /// Phase 1: Soft peach/cream card with downward chevron and orange-divided route rows
  Widget _buildPhase1RouteList(
    List<_RouteMatchResult> items,
    bool showingNearestFallback,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0E6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 2),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black87,
              size: 26,
            ),
          ),
          if (showingNearestFallback)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF7941D).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'No direct route passes both locations. Showing nearest routes:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A4400),
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => Container(
                height: 2.5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7941D),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              itemBuilder: (context, index) {
                final match = items[index];
                final route = match.route;
                return InkWell(
                  onTap: () => _selectRouteForPreview(route),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ROUTE ${route.routeNumber} - ${route.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (!match.isDirectMatch &&
                                match.nearestDistanceMeters < 9000)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B6770),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '~${match.nearestDistanceMeters.round()}m away',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'via ${route.corridorSummary}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Price Range : ₱${route.minRegularFare.toStringAsFixed(2)} - ₱${route.maxRegularFare.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Phase 2: Full teal route info sheet with Min/Max regular fare coin containers + TRACK button
  Widget _buildPhase2PreviewSheet(ElptrpRoute route) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF28848B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chevron to return to Phase 1 route list
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _phase = _RoutePagePhase.searchList;
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          Text(
            'ROUTE ${route.routeNumber}: ${route.name}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'via ${route.corridorSummary}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          // TWO COIN CONTAINERS: Minimum Fare (Left) & Maximum Regular Fare (Right)
          Row(
            children: [
              Expanded(
                child: _buildCoinFareCard(
                  label: 'MIN FARE',
                  amount: route.minRegularFare,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCoinFareCard(
                  label: 'MAX FARE',
                  amount: route.maxRegularFare,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // TRACK BUTTON (Lowers info container into Phase 3)
          GestureDetector(
            onTap: () {
              setState(() {
                _phase = _RoutePagePhase.tracking;
              });
            },
            child: Image.asset(
              'assets/route_page/track_button.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinFareCard({
    required String label,
    required double amount,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/route_page/price_container.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(left: 52, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '₱${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Phase 3: Lowered compact tracking panel focusing on the route map + END button
  Widget _buildPhase3TrackingSheet(ElptrpRoute route) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF28848B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upward chevron to expand back to Phase 2 preview
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _phase = _RoutePagePhase.routePreview;
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
          Text(
            'ROUTE ${route.routeNumber}: ${route.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'via ${route.corridorSummary}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Range: ₱${route.minRegularFare.toStringAsFixed(2)} - ₱${route.maxRegularFare.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _phase = _RoutePagePhase.routePreview;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7941D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'END',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}