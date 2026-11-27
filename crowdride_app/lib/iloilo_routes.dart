import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

/// Future-ready path tracer for moving objects (e.g., jeepneys) along a route's street path
class RoutePathTracer {
  final List<LatLng> waypoints;
  late final List<double> _segmentLengthsMeters;
  late final double totalDistanceMeters;

  RoutePathTracer(this.waypoints) {
    _segmentLengthsMeters = [];
    double sum = 0.0;
    const Distance distanceCalc = Distance();

    for (int i = 0; i < waypoints.length - 1; i++) {
      final meters = distanceCalc.as(
        LengthUnit.Meter,
        waypoints[i],
        waypoints[i + 1],
      );
      _segmentLengthsMeters.add(meters);
      sum += meters;
    }
    totalDistanceMeters = sum;
  }

  /// Returns exact LatLng and rotation angle (radians) at [distanceMeters] along the road
  ({LatLng position, double headingRadians}) sampleAtDistance(
    double distanceMeters, {
    bool loop = true,
  }) {
    if (waypoints.isEmpty) {
      return (position: const LatLng(10.7145, 122.5550), headingRadians: 0.0);
    }
    if (waypoints.length == 1 || totalDistanceMeters <= 0) {
      return (position: waypoints.first, headingRadians: 0.0);
    }

    double targetDist = loop
        ? distanceMeters % totalDistanceMeters
        : distanceMeters.clamp(0.0, totalDistanceMeters);

    for (int i = 0; i < _segmentLengthsMeters.length; i++) {
      final segLen = _segmentLengthsMeters[i];
      if (targetDist <= segLen && segLen > 0) {
        final t = targetDist / segLen;
        final start = waypoints[i];
        final end = waypoints[i + 1];

        final lat = start.latitude + (end.latitude - start.latitude) * t;
        final lng = start.longitude + (end.longitude - start.longitude) * t;

        final dx = end.longitude - start.longitude;
        final dy = -(end.latitude - start.latitude);
        final angle = atan2(dy, dx);

        return (position: LatLng(lat, lng), headingRadians: angle);
      }
      targetDist -= segLen;
    }

    return (position: waypoints.last, headingRadians: 0.0);
  }

  /// Convenience helper using normalized progress from 0.0 (start) to 1.0 (end)
  ({LatLng position, double headingRadians}) sampleAtProgress(double progress) {
    return sampleAtDistance(
      progress.clamp(0.0, 1.0) * totalDistanceMeters,
      loop: false,
    );
  }
}

/// A shared physical road segment in Iloilo City that snaps to OpenStreetMap road centerlines
class IloiloRoadSegment {
  final String id;
  final String roadName;
  final double congestionWeight;
  final List<LatLng> basePoints;
  List<LatLng>? _snappedPoints;

  IloiloRoadSegment({
    required this.id,
    required this.roadName,
    required this.congestionWeight,
    required this.basePoints,
  });

  List<LatLng> get points => _snappedPoints ?? basePoints;

  List<LatLng> get reversedPoints => points.reversed.toList();

  /// Forces this road segment onto exact OpenStreetMap road centerlines via OSRM Map Matching
  Future<bool> snapToOsmRoad() async {
    if (_snappedPoints != null) return true;
    if (basePoints.length < 2) return false;

    try {
      final coords = basePoints
          .map((p) =>
              '${p.longitude.toStringAsFixed(6)},${p.latitude.toStringAsFixed(6)}')
          .join(';');
      final radiuses = List.filled(basePoints.length, '40').join(';');

      // OSRM Map-Matching snaps points directly onto the nearest OSM street centerline
      final matchUri = Uri.parse(
        'https://router.project-osrm.org/match/v1/driving/$coords'
        '?overview=full&geometries=geojson&radiuses=$radiuses&gaps=ignore',
      );

      final response = await http
          .get(matchUri, headers: {'User-Agent': 'CrowdRideIloiloApp/1.0'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final matchings = data['matchings'] as List<dynamic>?;
        if (matchings != null && matchings.isNotEmpty) {
          final List<LatLng> combined = [];
          for (final m in matchings) {
            final geom = (m as Map<String, dynamic>)['geometry']
                as Map<String, dynamic>;
            final rawCoords = geom['coordinates'] as List<dynamic>;
            for (final c in rawCoords) {
              final pt = LatLng(
                (c[1] as num).toDouble(),
                (c[0] as num).toDouble(),
              );
              if (combined.isEmpty || combined.last != pt) {
                combined.add(pt);
              }
            }
          }
          if (combined.length >= 2) {
            _snappedPoints = combined;
            return true;
          }
        }
      }
    } catch (_) {
      // Keeps dense street-centerline coordinates if offline
    }
    return false;
  }
}

/// Shared road corridors of Iloilo City so all 25 routes and the Traffic Heatmap align 1:1
class IloiloRoadCorridors {
  // 1. Lopez Jaena St (Ungka -> CPU -> Jaro Plaza North)
  static final lopezJaena = IloiloRoadSegment(
    id: 'lopez_jaena',
    roadName: 'Lopez Jaena St (Ungka - CPU - Jaro)',
    congestionWeight: 0.85,
    basePoints: const [
      LatLng(10.7429, 122.5361), // Ungka Highway Junction
      LatLng(10.7385, 122.5408), // Ungka - Sambag
      LatLng(10.7346, 122.5458), // Sambag
      LatLng(10.7315, 122.5498), // CPU Main Gate
      LatLng(10.7290, 122.5531), // Arguelles / Lopez Jaena
      LatLng(10.7273, 122.5553), // Jaro Cathedral / Democracia
      LatLng(10.7259, 122.5572), // Jaro Plaza North
    ],
  );

  // 2. Jaro Plaza Perimeter (North -> West -> South -> East -> North)
  static const LatLng jaroNorth = LatLng(10.7259, 122.5572);
  static const LatLng jaroWest = LatLng(10.7247, 122.5559);
  static const LatLng jaroSouth = LatLng(10.7240, 122.5573);
  static const LatLng jaroEast = LatLng(10.7253, 122.5582);

  // 3. E. Lopez St & McArthur Drive (Jaro Plaza East -> Jaro Bridge -> Buhang -> Tagbak)
  static final mcArthurDrive = IloiloRoadSegment(
    id: 'mcarthur_drive',
    roadName: 'E. Lopez St & McArthur Drive (Jaro - Tagbak)',
    congestionWeight: 0.86,
    basePoints: const [
      LatLng(10.7253, 122.5582), // Jaro Plaza East
      LatLng(10.7275, 122.5592), // E. Lopez St
      LatLng(10.7296, 122.5602), // Jaro Bridge
      LatLng(10.7354, 122.5638), // Buhang
      LatLng(10.7445, 122.5688), // Tagbak Proper
      LatLng(10.7522, 122.5735), // Tagbak Ceres Terminal
    ],
  );

  // 4. Luna St & Forbes Bridge (Jaro Plaza South -> WVSU -> La Paz -> Forbes Bridge -> Capitol)
  static final lunaStreet = IloiloRoadSegment(
    id: 'luna_street',
    roadName: 'Luna St - WVSU - Forbes Bridge Corridor',
    congestionWeight: 0.93,
    basePoints: const [
      LatLng(10.7240, 122.5573), // Jaro Plaza South
      LatLng(10.7215, 122.5589), // Luna St / Seminario
      LatLng(10.7182, 122.5610), // Luna St / E. Lopez
      LatLng(10.7145, 122.5633), // WVSU Main Gate
      LatLng(10.7105, 122.5658), // Luna St / La Paz
      LatLng(10.7065, 122.5680), // Forbes Bridge North
      LatLng(10.7045, 122.5683), // Forbes Bridge
      LatLng(10.6995, 122.5684), // Capitol / Bonifacio Junction
    ],
  );

  // 5. Jaro-Mandurriao Rd (Jaro Plaza West -> Dungon Bridge -> Diversion Rd)
  static final dungonRoad = IloiloRoadSegment(
    id: 'dungon_road',
    roadName: 'Jaro - Dungon - Mandurriao Road',
    congestionWeight: 0.78,
    basePoints: const [
      LatLng(10.7247, 122.5559), // Jaro Plaza West
      LatLng(10.7231, 122.5539), // Jaro National High School
      LatLng(10.7212, 122.5517), // Dungon Bridge
      LatLng(10.7198, 122.5491), // Dungon / Diversion Rd
    ],
  );

  // 6. Sen. Benigno Aquino Jr. Ave / Diversion Rd (Ungka -> Megaworld -> SM City -> Esplanade -> Infante)
  static final diversionRoad = IloiloRoadSegment(
    id: 'diversion_road',
    roadName: 'Sen. Benigno Aquino Jr. Ave (Diversion Rd)',
    congestionWeight: 0.96,
    basePoints: const [
      LatLng(10.7429, 122.5361), // Ungka Highway Junction
      LatLng(10.7355, 122.5403), // Diversion North
      LatLng(10.7285, 122.5442), // Bakhaw / Diversion
      LatLng(10.7198, 122.5491), // Megaworld / Dungon Junction
      LatLng(10.7145, 122.5515), // SM City Iloilo
      LatLng(10.7086, 122.5546), // Esplanade North / Atria
      LatLng(10.7046, 122.5564), // Diversion Bridge
      LatLng(10.7012, 122.5572), // Infante Flyover
    ],
  );

  // 7. General Luna St (Infante Flyover -> UPV / San Agustin -> Capitol)
  static final generalLuna = IloiloRoadSegment(
    id: 'general_luna',
    roadName: 'General Luna St (Infante - UPV - Capitol)',
    congestionWeight: 0.89,
    basePoints: const [
      LatLng(10.7012, 122.5572), // Infante Flyover
      LatLng(10.6999, 122.5618), // UPV / University of San Agustin
      LatLng(10.6995, 122.5684), // Capitol Junction
    ],
  );

  // 8. Iznart St & JM Basa St / Calle Real (Capitol -> Central Market -> Plaza Libertad)
  static final iznartJmBasa = IloiloRoadSegment(
    id: 'iznart_jmbasa',
    roadName: 'Iznart St & JM Basa St (Downtown)',
    congestionWeight: 0.96,
    basePoints: const [
      LatLng(10.6995, 122.5684), // Capitol Junction
      LatLng(10.6958, 122.5695), // Iznart St / Marymart
      LatLng(10.6939, 122.5701), // Central Market
      LatLng(10.6934, 122.5718), // JM Basa St (Calle Real)
      LatLng(10.6927, 122.5734), // Plaza Libertad
    ],
  );

  // 9. Infante Ave & Ledesma St (Infante Flyover -> Super -> Iznart -> Plaza Libertad)
  static final infanteLedesma = IloiloRoadSegment(
    id: 'infante_ledesma',
    roadName: 'Infante Ave & Ledesma St (Super)',
    congestionWeight: 0.88,
    basePoints: const [
      LatLng(10.7012, 122.5572), // Infante Flyover
      LatLng(10.6974, 122.5585), // Infante Ave
      LatLng(10.6941, 122.5645), // Iloilo Terminal Market (Super)
      LatLng(10.6946, 122.5700), // Ledesma / Iznart
      LatLng(10.6934, 122.5718), // JM Basa St
      LatLng(10.6927, 122.5734), // Plaza Libertad
    ],
  );

  // 10. Delgado St (Infante -> Robinsons Place Iloilo -> Iznart)
  static final delgadoStreet = IloiloRoadSegment(
    id: 'delgado_street',
    roadName: 'Delgado St (Robinsons Iloilo)',
    congestionWeight: 0.84,
    basePoints: const [
      LatLng(10.6974, 122.5585), // Delgado / Infante
      LatLng(10.6968, 122.5645), // Robinsons Place Iloilo
      LatLng(10.6967, 122.5692), // Delgado / Iznart
    ],
  );

  // 11. Molo - Arevalo - Mohon Highway (Infante -> Molo Plaza -> Arevalo -> Mohon)
  static final moloArevaloHighway = IloiloRoadSegment(
    id: 'molo_arevalo',
    roadName: 'Avanceña St - Molo - Arevalo - Mohon Highway',
    congestionWeight: 0.80,
    basePoints: const [
      LatLng(10.7012, 122.5572), // Infante Flyover
      LatLng(10.6991, 122.5535), // Avanceña St / Timawa
      LatLng(10.6968, 122.5446), // Molo Plaza
      LatLng(10.6939, 122.5367), // San Juan Molo
      LatLng(10.6915, 122.5312), // Calumpang
      LatLng(10.6891, 122.5162), // Arevalo Plaza
      LatLng(10.6867, 122.5026), // Mohon Terminal
    ],
  );

  // 12. R. Mapa St & Carpenter Bridge (Mandurriao Plaza -> Carpenter Bridge -> Molo Plaza)
  static final mandurriaoMolo = IloiloRoadSegment(
    id: 'mandurriao_molo',
    roadName: 'R. Mapa St & Carpenter Bridge (Mandurriao - Molo)',
    congestionWeight: 0.76,
    basePoints: const [
      LatLng(10.7204, 122.5359), // Mandurriao Plaza
      LatLng(10.7136, 122.5396), // R. Mapa St
      LatLng(10.7072, 122.5431), // Carpenter Bridge North
      LatLng(10.7042, 122.5441), // Carpenter Bridge South
      LatLng(10.6968, 122.5446), // Molo Plaza
    ],
  );

  // 13. Mandurriao - Festive Walk - Diversion Connector
  static final mandurriaoFestive = IloiloRoadSegment(
    id: 'mandurriao_festive',
    roadName: 'Mandurriao - Megaworld / Festive Walk',
    congestionWeight: 0.72,
    basePoints: const [
      LatLng(10.7235, 122.5260), // Hibao-an
      LatLng(10.7204, 122.5359), // Mandurriao Plaza
      LatLng(10.7181, 122.5453), // Festive Walk Transport Hub
      LatLng(10.7198, 122.5491), // Megaworld / Diversion Rd
    ],
  );

  // 14. Lapuz - Bo. Obrero - Muelle Loney Waterfront
  static final lapuzMuelleLoney = IloiloRoadSegment(
    id: 'lapuz_muelle',
    roadName: 'Bo. Obrero - Lapuz - Muelle Loney',
    congestionWeight: 0.68,
    basePoints: const [
      LatLng(10.6978, 122.5853), // Bo. Obrero
      LatLng(10.7016, 122.5806), // Lapuz Ave
      LatLng(10.7023, 122.5776), // Drilon Bridge
      LatLng(10.6994, 122.5762), // Muelle Loney North
      LatLng(10.6948, 122.5768), // Parola Ferry Terminal
      LatLng(10.6927, 122.5734), // Plaza Libertad
    ],
  );

  // 15. La Paz - ISAT U - Ticud Loop
  static final laPazLoop = IloiloRoadSegment(
    id: 'lapaz_loop',
    roadName: 'La Paz Plaza - ISAT U - Ticud',
    congestionWeight: 0.66,
    basePoints: const [
      LatLng(10.7182, 122.5610), // E. Lopez / Luna St
      LatLng(10.7157, 122.5658), // ISAT U
      LatLng(10.7128, 122.5724), // Ticud La Paz
      LatLng(10.7104, 122.5692), // La Paz Plaza
      LatLng(10.7105, 122.5658), // Huervana / Luna St
    ],
  );

  static final List<IloiloRoadSegment> allSegments = [
    lopezJaena,
    mcArthurDrive,
    lunaStreet,
    dungonRoad,
    diversionRoad,
    generalLuna,
    iznartJmBasa,
    infanteLedesma,
    delgadoStreet,
    moloArevaloHighway,
    mandurriaoMolo,
    mandurriaoFestive,
    lapuzMuelleLoney,
    laPazLoop,
  ];
}

/// Joins multiple point lists cleanly without duplicating shared intersection vertices
List<LatLng> _stitchRoadPaths(List<List<LatLng>> segments) {
  final List<LatLng> result = [];
  for (final seg in segments) {
    for (final pt in seg) {
      if (result.isEmpty || result.last != pt) {
        result.add(pt);
      }
    }
  }
  return result;
}

class ElptrpRoute {
  final int routeNumber;
  final String name;
  final String corridorSummary;
  final Color color;
  final List<LatLng> Function() _pathBuilder;
  late RoutePathTracer tracer;

  ElptrpRoute({
    required this.routeNumber,
    required this.name,
    required this.corridorSummary,
    required this.color,
    required List<LatLng> Function() pathBuilder,
  }) : _pathBuilder = pathBuilder {
    rebuildTracer();
  }

  String get routeCode => 'Route $routeNumber';

  List<LatLng> get activeWaypoints => _pathBuilder();

  /// Minimum regular passenger fare (first 4 km base rate in Iloilo City)
  double get minRegularFare => 15.00;

  /// Maximum end-to-end regular passenger fare for the full route distance
  double get maxRegularFare {
    final double km = tracer.totalDistanceMeters / 1000.0;
    if (km <= 4.0) return 15.00;
    final double extraKm = km - 4.0;
    final double rawFare = 15.00 + (extraKm * 2.20);
    return (rawFare * 2).round() / 2.0;
  }

  /// Shortest distance in meters from [target] to any road segment along this route
  double distanceToPointMeters(LatLng target) {
    final pts = activeWaypoints;
    if (pts.isEmpty) return double.infinity;
    if (pts.length == 1) {
      return const Distance().as(LengthUnit.Meter, pts.first, target);
    }

    const double metersPerDegLat = 110574.0;
    const double metersPerDegLng = 111320.0 * 0.9826; // cos(10.71° Iloilo latitude)

    final double px = target.longitude * metersPerDegLng;
    final double py = target.latitude * metersPerDegLat;

    double minDistSq = double.infinity;

    for (int i = 0; i < pts.length - 1; i++) {
      final double ax = pts[i].longitude * metersPerDegLng;
      final double ay = pts[i].latitude * metersPerDegLat;
      final double bx = pts[i + 1].longitude * metersPerDegLng;
      final double by = pts[i + 1].latitude * metersPerDegLat;

      final double abx = bx - ax;
      final double aby = by - ay;
      final double lenSq = abx * abx + aby * aby;

      double t = 0.0;
      if (lenSq > 0) {
        t = (((px - ax) * abx + (py - ay) * aby) / lenSq).clamp(0.0, 1.0);
      }

      final double cx = ax + t * abx;
      final double cy = ay + t * aby;
      final double dx = px - cx;
      final double dy = py - cy;
      final double distSq = dx * dx + dy * dy;

      if (distSq < minDistSq) {
        minDistSq = distSq;
      }
    }

    return sqrt(minDistSq);
  }

  /// Clips the snapped road waypoints to the exact sub-segment between [fromPoint] and [destPoint]
  List<LatLng> extractSubPath(LatLng fromPoint, LatLng destPoint) {
    final pts = activeWaypoints;
    if (pts.length < 2) return [];

    int closestIndex(LatLng target) {
      const dist = Distance();
      int bestIdx = 0;
      double bestMeters = double.infinity;
      for (int i = 0; i < pts.length; i++) {
        final d = dist.as(LengthUnit.Meter, pts[i], target);
        if (d < bestMeters) {
          bestMeters = d;
          bestIdx = i;
        }
      }
      return bestIdx;
    }

    final int startIdx = closestIndex(fromPoint);
    final int endIdx = closestIndex(destPoint);

    if (startIdx == endIdx) {
      final int next = (startIdx + 1).clamp(0, pts.length - 1);
      return startIdx == next ? [] : [pts[startIdx], pts[next]];
    }

    if (startIdx < endIdx) {
      return pts.sublist(startIdx, endIdx + 1);
    } else {
      return pts.sublist(endIdx, startIdx + 1).reversed.toList();
    }
  }

  void rebuildTracer() {
    tracer = RoutePathTracer(activeWaypoints);
  }
}

enum TrafficSeverity { freeFlow, moderate, heavy, severe }

class TrafficRoadSegment {
  final IloiloRoadSegment road;

  const TrafficRoadSegment(this.road);

  String get roadName => road.roadName;
  List<LatLng> get points => road.points;

  TrafficSeverity evaluateAt(DateTime time) {
    final double hourDecimal = time.hour + (time.minute / 60.0);

    final bool isMorningRush = hourDecimal >= 6.5 && hourDecimal <= 9.5;
    final bool isEveningRush = hourDecimal >= 16.5 && hourDecimal <= 19.5;
    final bool isMiddayBusy = hourDecimal >= 11.5 && hourDecimal <= 13.5;
    final bool isLateNight = hourDecimal >= 21.5 || hourDecimal < 5.5;

    double timeMultiplier;
    if (isEveningRush) {
      timeMultiplier = 1.0;
    } else if (isMorningRush) {
      timeMultiplier = 0.92;
    } else if (isMiddayBusy) {
      timeMultiplier = 0.65;
    } else if (isLateNight) {
      timeMultiplier = 0.15;
    } else {
      timeMultiplier = 0.45;
    }

    final double score = road.congestionWeight * timeMultiplier;
    if (score >= 0.78) return TrafficSeverity.severe;
    if (score >= 0.55) return TrafficSeverity.heavy;
    if (score >= 0.32) return TrafficSeverity.moderate;
    return TrafficSeverity.freeFlow;
  }

  static Color colorForSeverity(TrafficSeverity severity) {
    switch (severity) {
      case TrafficSeverity.severe:
        return const Color(0xFFD50000);
      case TrafficSeverity.heavy:
        return const Color(0xFFFF6D00);
      case TrafficSeverity.moderate:
        return const Color(0xFFFFD600);
      case TrafficSeverity.freeFlow:
        return const Color(0xFF00C853);
    }
  }
}

/// Manages snapping all shared Iloilo City road corridors onto OpenStreetMap centerlines
class IloiloOsmRoadNetwork {
  static bool isLoaded = false;
  static bool _loading = false;

  static final List<TrafficRoadSegment> trafficCorridors =
      IloiloRoadCorridors.allSegments
          .map((seg) => TrafficRoadSegment(seg))
          .toList();

  static Future<bool> syncFromOverpass({bool forceRefresh = false}) async {
    if (isLoaded && !forceRefresh) return true;
    if (_loading) return false;
    _loading = true;

    try {
      int snappedCount = 0;
      // Snap shared corridors in small concurrent batches
      const int batchSize = 4;
      final segments = IloiloRoadCorridors.allSegments;

      for (int i = 0; i < segments.length; i += batchSize) {
        final batch = segments.skip(i).take(batchSize);
        final results = await Future.wait(batch.map((s) => s.snapToOsmRoad()));
        snappedCount += results.where((ok) => ok).length;
      }

      if (snappedCount > 0) {
        for (final route in iloiloElptrpRoutes) {
          route.rebuildTracer();
        }
        isLoaded = true;
        return true;
      }
      return false;
    } finally {
      _loading = false;
    }
  }
}

/// All 25 Iloilo City Enhanced Local Public Transport Route Plan (ELPTRP) Routes
/// Built directly from the shared road corridors so every line follows the exact same street geometry
final List<ElptrpRoute> iloiloElptrpRoutes = [
  ElptrpRoute(
    routeNumber: 1,
    name: 'Bo. Obrero - Iloilo City Proper Loop',
    corridorSummary: 'Bo. Obrero • Lapuz • Muelle Loney • Plaza Libertad • Iznart',
    color: const Color(0xFFE53935),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.lapuzMuelleLoney.points,
      IloiloRoadCorridors.iznartJmBasa.reversedPoints,
      const [LatLng(10.7045, 122.5683), LatLng(10.7023, 122.5776)],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 2,
    name: 'Calaparan - Iloilo City Proper',
    corridorSummary: 'Calaparan • Molo Plaza • General Luna • UPV • City Proper',
    color: const Color(0xFFD81B60),
    pathBuilder: () => _stitchRoadPaths([
      const [LatLng(10.6895, 122.5290)],
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints.skip(3).toList(),
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 3,
    name: 'Ungka - Iloilo City Proper via CPU',
    corridorSummary: 'Ungka Terminal • CPU • Jaro Plaza • Luna St • WVSU • Iznart',
    color: const Color(0xFF8E24AA),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.lopezJaena.points,
      const [
        IloiloRoadCorridors.jaroNorth,
        IloiloRoadCorridors.jaroWest,
        IloiloRoadCorridors.jaroSouth,
      ],
      IloiloRoadCorridors.lunaStreet.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 4,
    name: 'Ungka - Iloilo City Proper via Diversion / Festive Walk',
    corridorSummary: 'Ungka • Diversion Rd • Festive Walk • SM City • Infante • Super',
    color: const Color(0xFF5E35B1),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.diversionRoad.points,
      IloiloRoadCorridors.infanteLedesma.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 5,
    name: 'Festive Walk Transport Hub - Iloilo City Proper via SM City',
    corridorSummary: 'Festive Walk • SM City • General Luna • Robinsons • City Proper',
    color: const Color(0xFF3949AB),
    pathBuilder: () => _stitchRoadPaths([
      const [LatLng(10.7181, 122.5453)],
      IloiloRoadCorridors.diversionRoad.points.skip(3).toList(),
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 6,
    name: 'Lanit - Iloilo City Proper via SM City',
    corridorSummary: 'Lanit • Quintin Salas • Jaro • Dungon • SM City • City Proper',
    color: const Color(0xFF1E88E5),
    pathBuilder: () => _stitchRoadPaths([
      const [
        LatLng(10.7545, 122.5555),
        LatLng(10.7440, 122.5558),
        LatLng(10.7355, 122.5560),
        LatLng(10.7302, 122.5556),
        IloiloRoadCorridors.jaroNorth,
        IloiloRoadCorridors.jaroWest,
      ],
      IloiloRoadCorridors.dungonRoad.points,
      IloiloRoadCorridors.diversionRoad.points.skip(3).toList(),
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 7,
    name: 'Compania - Iloilo City Proper Loop',
    corridorSummary: 'Compania Fundidor • Molo Plaza • Timawa • Delgado • City Proper',
    color: const Color(0xFF039BE5),
    pathBuilder: () => _stitchRoadPaths([
      const [LatLng(10.6925, 122.5380), LatLng(10.6968, 122.5446)],
      const [LatLng(10.6991, 122.5535), LatLng(10.7012, 122.5572)],
      const [LatLng(10.6974, 122.5585)],
      IloiloRoadCorridors.delgadoStreet.points,
      IloiloRoadCorridors.iznartJmBasa.points.skip(1).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 8,
    name: 'Parola - Infante via Super Loop',
    corridorSummary: 'Parola Wharf • Ortiz • Plaza Libertad • Super • Infante Loop',
    color: const Color(0xFF00ACC1),
    pathBuilder: () => _stitchRoadPaths([
      const [
        LatLng(10.6948, 122.5768),
        LatLng(10.6908, 122.5752),
        LatLng(10.6927, 122.5734),
      ],
      IloiloRoadCorridors.infanteLedesma.reversedPoints,
      IloiloRoadCorridors.generalLuna.points,
      const [LatLng(10.6948, 122.5768)],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 9,
    name: 'Mohon - Infante Loop',
    corridorSummary: 'Mohon Terminal • Arevalo • Molo Blvd • Infante Flyover',
    color: const Color(0xFF00897B),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 10,
    name: 'Tagbak - Iloilo City Proper',
    corridorSummary: 'Tagbak Terminal • Buhang • Jaro Plaza • Luna St • Iznart',
    color: const Color(0xFF43A047),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mcArthurDrive.reversedPoints,
      const [
        IloiloRoadCorridors.jaroEast,
        IloiloRoadCorridors.jaroSouth,
      ],
      IloiloRoadCorridors.lunaStreet.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 11,
    name: 'Ticud, La Paz - Iloilo City Proper',
    corridorSummary: 'Ticud • La Paz Plaza • Forbes Bridge • Iznart • City Proper',
    color: const Color(0xFF7CB342),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.laPazLoop.points.skip(2).toList(),
      IloiloRoadCorridors.lunaStreet.points.skip(4).toList(),
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 12,
    name: 'Mandurriao - Molo via Festivity / SM City',
    corridorSummary: 'Mandurriao Plaza • Festive Walk • SM City • San Rafael • Molo',
    color: const Color(0xFFC0CA33),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mandurriaoFestive.points.skip(1).toList(),
      const [
        LatLng(10.7198, 122.5491),
        LatLng(10.7145, 122.5515),
        LatLng(10.7126, 122.5482),
      ],
      IloiloRoadCorridors.mandurriaoMolo.points.skip(2).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 13,
    name: 'Hibao-an - Iloilo City Proper via Tabucan / SM City',
    corridorSummary: 'Hibao-an • Mandurriao • Tabucan • SM City • General Luna',
    color: const Color(0xFFFDD835),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mandurriaoFestive.points,
      IloiloRoadCorridors.diversionRoad.points.skip(3).toList(),
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 14,
    name: 'Hibao-an - Jaro via Bakhaw / Festive Walk',
    corridorSummary: 'Hibao-an • Mandurriao • Bakhaw • Festive Walk • Dungon • Jaro',
    color: const Color(0xFFFFB300),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mandurriaoFestive.points,
      IloiloRoadCorridors.dungonRoad.reversedPoints,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 15,
    name: 'Molo - Iloilo City Proper via Baluarte Loop',
    corridorSummary: 'Molo Plaza • Baluarte • Tanza • Super • City Proper Loop',
    color: const Color(0xFFFB8C00),
    pathBuilder: () => _stitchRoadPaths([
      const [
        LatLng(10.6968, 122.5446),
        LatLng(10.6885, 122.5485),
        LatLng(10.6912, 122.5635),
      ],
      IloiloRoadCorridors.infanteLedesma.points.skip(2).toList(),
      IloiloRoadCorridors.iznartJmBasa.reversedPoints,
      IloiloRoadCorridors.generalLuna.reversedPoints,
      IloiloRoadCorridors.moloArevaloHighway.points.take(3).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 16,
    name: 'Sto. Niño Sur - Iloilo City Proper via Villa',
    corridorSummary: 'Sto. Niño Sur • Arevalo Plaza • Molo • General Luna • City Proper',
    color: const Color(0xFFF4511E),
    pathBuilder: () => _stitchRoadPaths([
      const [LatLng(10.6845, 122.4965)],
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints,
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 17,
    name: 'Villa Baybay - Iloilo City Proper via Bonifacio',
    corridorSummary: 'Villa Baybay • Arevalo • Molo • Delgado • Bonifacio Drive',
    color: const Color(0xFF6D4C41),
    pathBuilder: () => _stitchRoadPaths([
      const [LatLng(10.6815, 122.5120)],
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints.skip(1).toList(),
      const [LatLng(10.6974, 122.5585)],
      IloiloRoadCorridors.delgadoStreet.points,
      IloiloRoadCorridors.iznartJmBasa.points.skip(1).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 18,
    name: 'Tagbak - Mandurriao via Jaro / Guzman',
    corridorSummary: 'Tagbak Terminal • Jaro Plaza • CPU • Guzman St • Mandurriao Plaza',
    color: const Color(0xFF546E7A),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mcArthurDrive.reversedPoints,
      const [
        IloiloRoadCorridors.jaroEast,
        IloiloRoadCorridors.jaroNorth,
      ],
      IloiloRoadCorridors.lopezJaena.reversedPoints.take(4).toList(),
      const [
        LatLng(10.7258, 122.5425),
        LatLng(10.7204, 122.5359),
      ],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 19,
    name: 'Bito-on - Jaro via Balabago Loop',
    corridorSummary: 'Bito-on • Balabago • Tabuc Suba • Jaro Big Market • Jaro Plaza',
    color: const Color(0xFF2E7D32),
    pathBuilder: () => _stitchRoadPaths([
      const [
        LatLng(10.7465, 122.5875),
        LatLng(10.7410, 122.5780),
      ],
      IloiloRoadCorridors.mcArthurDrive.reversedPoints.skip(3).toList(),
      const [
        IloiloRoadCorridors.jaroEast,
        IloiloRoadCorridors.jaroSouth,
        IloiloRoadCorridors.jaroWest,
        IloiloRoadCorridors.jaroNorth,
      ],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 20,
    name: 'Mohon - Jaro via Mandurriao',
    corridorSummary: 'Mohon • Arevalo • Molo • Mandurriao Plaza • Dungon • Jaro Plaza',
    color: const Color(0xFF1565C0),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints.take(5).toList(),
      IloiloRoadCorridors.mandurriaoMolo.reversedPoints,
      IloiloRoadCorridors.mandurriaoFestive.points.skip(1).toList(),
      IloiloRoadCorridors.dungonRoad.reversedPoints,
    ]),
  ),
  ElptrpRoute(
    routeNumber: 21,
    name: 'Tagbak - Festive Walk via SM City / Atria',
    corridorSummary: 'Tagbak • Jaro • Diversion Rd • SM City • Atria • Festive Walk',
    color: const Color(0xFF6A1B9A),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.mcArthurDrive.reversedPoints,
      const [
        IloiloRoadCorridors.jaroEast,
        IloiloRoadCorridors.jaroSouth,
        IloiloRoadCorridors.jaroWest,
      ],
      IloiloRoadCorridors.dungonRoad.points,
      const [
        LatLng(10.7198, 122.5491),
        LatLng(10.7145, 122.5515),
        LatLng(10.7086, 122.5546),
        LatLng(10.7181, 122.5453),
      ],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 22,
    name: 'Ungka - La Paz via CPU - ISAT U Loop',
    corridorSummary: 'Ungka • CPU • Jaro Plaza • ISAT U • WVSU • La Paz Plaza',
    color: const Color(0xFFAD1457),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.lopezJaena.points,
      const [
        IloiloRoadCorridors.jaroNorth,
        IloiloRoadCorridors.jaroWest,
        IloiloRoadCorridors.jaroSouth,
        LatLng(10.7215, 122.5589),
      ],
      IloiloRoadCorridors.laPazLoop.points,
      IloiloRoadCorridors.lunaStreet.reversedPoints.skip(3).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 23,
    name: 'Mohon - Mandurriao Business Park',
    corridorSummary: 'Mohon Terminal • Arevalo • Molo • Carpenter Bridge • Festive Walk',
    color: const Color(0xFF00695C),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints.take(5).toList(),
      IloiloRoadCorridors.mandurriaoMolo.reversedPoints,
      IloiloRoadCorridors.mandurriaoFestive.points.skip(1).take(2).toList(),
    ]),
  ),
  ElptrpRoute(
    routeNumber: 24,
    name: 'La Paz - Festive Walk via Nabitasan Loop',
    corridorSummary: 'La Paz Plaza • WVSU • Nabitasan • Gaisano ICC • SM City • Festive Walk',
    color: const Color(0xFFEF6C00),
    pathBuilder: () => _stitchRoadPaths([
      const [
        LatLng(10.7104, 122.5692),
        LatLng(10.7105, 122.5658),
        LatLng(10.7065, 122.5680),
        LatLng(10.7052, 122.5588),
        LatLng(10.7086, 122.5546),
        LatLng(10.7145, 122.5515),
        LatLng(10.7198, 122.5491),
        LatLng(10.7181, 122.5453),
      ],
    ]),
  ),
  ElptrpRoute(
    routeNumber: 25,
    name: 'Molo - City Proper via General Luna Loop',
    corridorSummary: 'Molo Plaza • General Luna • UPV • Robinsons • Plaza Libertad Loop',
    color: const Color(0xFF283593),
    pathBuilder: () => _stitchRoadPaths([
      IloiloRoadCorridors.moloArevaloHighway.reversedPoints.skip(4).toList(),
      IloiloRoadCorridors.generalLuna.points,
      IloiloRoadCorridors.iznartJmBasa.points,
      IloiloRoadCorridors.infanteLedesma.reversedPoints,
      IloiloRoadCorridors.moloArevaloHighway.points.take(3).toList(),
    ]),
  ),
];