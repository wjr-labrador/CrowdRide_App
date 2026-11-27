import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

class IloiloPlace {
  final String name;
  final String category;
  final String district;
  final LatLng coordinates;
  final List<String> keywords;

  const IloiloPlace({
    required this.name,
    required this.category,
    required this.district,
    required this.coordinates,
    this.keywords = const [],
  });
}

/// Returns a matching Material icon for every category in this file
IconData iconForIloiloCategory(String category) {
  switch (category) {
    case 'School':
      return Icons.school;
    case 'Public Market':
      return Icons.storefront;
    case 'Mall':
      return Icons.local_mall;
    case 'Hospital':
      return Icons.local_hospital;
    case 'Fire Station':
      return Icons.local_fire_department;
    case 'Park / Plaza':
      return Icons.park;
    case 'Cemetery':
      return Icons.account_balance_outlined;
    case 'Church':
      return Icons.church;
    case 'Landmark':
      return Icons.photo_camera;
    case 'Government':
    case 'City Hall':
      return Icons.account_balance;
    case 'Restaurant':
      return Icons.restaurant;
    case 'Leisure':
      return Icons.attractions;
    case 'Terminal':
      return Icons.directions_bus;
    case 'District':
      return Icons.map;
    case 'Barangay':
      return Icons.holiday_village;
    default:
      return Icons.location_on;
  }
}

// =============================================================================
// 1. SCHOOLS, COLLEGES & UNIVERSITIES
// =============================================================================
const List<IloiloPlace> iloiloSchools = [
  IloiloPlace(
    name: 'West Visayas State University (WVSU)',
    category: 'School',
    district: 'La Paz',
    coordinates: LatLng(10.7138, 122.5625),
    keywords: ['wvsu', 'west', 'luna'],
  ),
  IloiloPlace(
    name: 'Central Philippine University (CPU)',
    category: 'School',
    district: 'Jaro',
    coordinates: LatLng(10.7303, 122.5484),
    keywords: ['cpu', 'central', 'lopez jaena'],
  ),
  IloiloPlace(
    name: 'University of the Philippines Visayas (UPV Iloilo City)',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6987, 122.5635),
    keywords: ['upv', 'up', 'general luna'],
  ),
  IloiloPlace(
    name: 'University of San Agustin (USA)',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6996, 122.5612),
    keywords: ['usa', 'san agustin', 'general luna'],
  ),
  IloiloPlace(
    name: 'Iloilo Science and Technology University (ISAT U)',
    category: 'School',
    district: 'La Paz',
    coordinates: LatLng(10.7157, 122.5658),
    keywords: ['isatu', 'isat', 'burgos'],
  ),
  IloiloPlace(
    name: 'PHINMA University of Iloilo (UI)',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6948, 122.5673),
    keywords: ['ui', 'phinma', 'rizal'],
  ),
  IloiloPlace(
    name: 'Western Institute of Technology (WIT)',
    category: 'School',
    district: 'La Paz',
    coordinates: LatLng(10.7118, 122.5665),
    keywords: ['wit', 'luna'],
  ),
  IloiloPlace(
    name: 'John B. Lacson Foundation Maritime University (Molo)',
    category: 'School',
    district: 'Molo',
    coordinates: LatLng(10.6952, 122.5478),
    keywords: ['jbl', 'john b', 'maritime', 'molo'],
  ),
  IloiloPlace(
    name: 'John B. Lacson Foundation Maritime University (Arevalo)',
    category: 'School',
    district: 'Arevalo',
    coordinates: LatLng(10.6869, 122.5112),
    keywords: ['jbl', 'john b', 'maritime', 'arevalo', 'sto nino'],
  ),
  IloiloPlace(
    name: 'St. Paul University Iloilo',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6997, 122.5656),
    keywords: ['spui', 'st paul', 'general luna'],
  ),
  IloiloPlace(
    name: 'Ateneo de Iloilo - Santa Maria Catholic School',
    category: 'School',
    district: 'Mandurriao',
    coordinates: LatLng(10.7068, 122.5446),
    keywords: ['ateneo', 'adi', 'san rafael', 'pison'],
  ),
  IloiloPlace(
    name: 'Philippine Science High School - Western Visayas (PSHS-WVC)',
    category: 'School',
    district: 'Jaro',
    coordinates: LatLng(10.7485, 122.5782),
    keywords: ['pisay', 'pshs', 'bito-on'],
  ),
  IloiloPlace(
    name: 'Iloilo National High School (INHS)',
    category: 'School',
    district: 'La Paz',
    coordinates: LatLng(10.7130, 122.5638),
    keywords: ['inhs', 'iloilo high', 'luna'],
  ),
  IloiloPlace(
    name: 'Jaro National High School',
    category: 'School',
    district: 'Jaro',
    coordinates: LatLng(10.7225, 122.5535),
    keywords: ['jnhs', 'jaro high', 'fajardo'],
  ),
  IloiloPlace(
    name: 'Hua Siong College of Iloilo (Main Campus)',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6955, 122.5688),
    keywords: ['hua siong', 'iznart'],
  ),
  IloiloPlace(
    name: 'Hua Siong College of Iloilo (Ledesco Campus)',
    category: 'School',
    district: 'La Paz',
    coordinates: LatLng(10.7222, 122.5665),
    keywords: ['hua siong', 'ledesco', 'tabuc suba'],
  ),
  IloiloPlace(
    name: 'Colegio de San Jose',
    category: 'School',
    district: 'Jaro',
    coordinates: LatLng(10.7270, 122.5582),
    keywords: ['csj', 'san jose', 'e lopez'],
  ),
  IloiloPlace(
    name: 'Assumption Iloilo',
    category: 'School',
    district: 'City Proper',
    coordinates: LatLng(10.6994, 122.5628),
    keywords: ['assumption', 'general luna'],
  ),
  IloiloPlace(
    name: 'Angelicum School Iloilo',
    category: 'School',
    district: 'Jaro',
    coordinates: LatLng(10.7335, 122.5612),
    keywords: ['angelicum', 'lizares', 'tabuc suba'],
  ),
  IloiloPlace(
    name: 'PAREF Westbridge School',
    category: 'School',
    district: 'Mandurriao',
    coordinates: LatLng(10.7225, 122.5320),
    keywords: ['westbridge', 'paref', 'hibao-an'],
  ),
  IloiloPlace(
    name: 'Santa Clarita International School',
    category: 'School',
    district: 'Molo',
    coordinates: LatLng(10.6942, 122.5395),
    keywords: ['santa clarita', 'princeton'],
  ),
  IloiloPlace(
    name: 'Iloilo Scholastic Academy (ISA)',
    category: 'School',
    district: 'Mandurriao',
    coordinates: LatLng(10.7138, 122.5418),
    keywords: ['isa', 'scholastic', 'tabucan'],
  ),
  IloiloPlace(
    name: 'St. Therese - MTC Colleges (La Fiesta)',
    category: 'School',
    district: 'Molo',
    coordinates: LatLng(10.6958, 122.5432),
    keywords: ['st therese', 'mtc', 'molo'],
  ),
  IloiloPlace(
    name: 'Iloilo City National High School',
    category: 'School',
    district: 'Molo',
    coordinates: LatLng(10.6945, 122.5528),
    keywords: ['icnhs', 'molo', 'timawa'],
  ),
];

// =============================================================================
// 2. PUBLIC MARKETS & TRADING CENTERS
// =============================================================================
const List<IloiloPlace> iloiloMarkets = [
  IloiloPlace(
    name: 'Iloilo Terminal Market (Super)',
    category: 'Public Market',
    district: 'City Proper',
    coordinates: LatLng(10.6938, 122.5645),
    keywords: ['super', 'terminal market', 'de leon'],
  ),
  IloiloPlace(
    name: 'Iloilo Central Market (Tienda Mayor)',
    category: 'Public Market',
    district: 'City Proper',
    coordinates: LatLng(10.6939, 122.5701),
    keywords: ['central market', 'tienda mayor', 'iznart', 'guanco'],
  ),
  IloiloPlace(
    name: 'Jaro Big Market',
    category: 'Public Market',
    district: 'Jaro',
    coordinates: LatLng(10.7268, 122.5592),
    keywords: ['jaro market', 'e lopez'],
  ),
  IloiloPlace(
    name: 'La Paz Public Market',
    category: 'Public Market',
    district: 'La Paz',
    coordinates: LatLng(10.7114, 122.5698),
    keywords: ['la paz market', 'batchoy', 'rizal'],
  ),
  IloiloPlace(
    name: 'Molo Public Market',
    category: 'Public Market',
    district: 'Molo',
    coordinates: LatLng(10.6959, 122.5442),
    keywords: ['molo market', 'locsin'],
  ),
  IloiloPlace(
    name: 'Arevalo Public Market',
    category: 'Public Market',
    district: 'Arevalo',
    coordinates: LatLng(10.6884, 122.5165),
    keywords: ['arevalo market', 'villa'],
  ),
  IloiloPlace(
    name: 'Mandurriao Public Market',
    category: 'Public Market',
    district: 'Mandurriao',
    coordinates: LatLng(10.7196, 122.5364),
    keywords: ['mandurriao market', 'r mapa'],
  ),
  IloiloPlace(
    name: 'Iloilo Fish Port Complex (Pala-Pala)',
    category: 'Public Market',
    district: 'Molo',
    coordinates: LatLng(10.6868, 122.5582),
    keywords: ['fish port', 'pala-pala', 'seafood', 'tansa'],
  ),
];

// =============================================================================
// 3. MALLS & SHOPPING CENTERS
// =============================================================================
const List<IloiloPlace> iloiloMalls = [
  IloiloPlace(
    name: 'SM City Iloilo',
    category: 'Mall',
    district: 'Mandurriao',
    coordinates: LatLng(10.7145, 122.5515),
    keywords: ['sm', 'sm city', 'diversion'],
  ),
  IloiloPlace(
    name: 'Festive Walk Mall Iloilo (Megaworld)',
    category: 'Mall',
    district: 'Mandurriao',
    coordinates: LatLng(10.7181, 122.5453),
    keywords: ['festive', 'megaworld', 'iloilo business park'],
  ),
  IloiloPlace(
    name: 'Robinsons Place Iloilo',
    category: 'Mall',
    district: 'City Proper',
    coordinates: LatLng(10.6968, 122.5645),
    keywords: ['robinsons', 'rob', 'delgado', 'ledesma'],
  ),
  IloiloPlace(
    name: 'Robinsons Place Jaro',
    category: 'Mall',
    district: 'Jaro',
    coordinates: LatLng(10.7282, 122.5614),
    keywords: ['robinsons jaro', 'e lopez'],
  ),
  IloiloPlace(
    name: 'Gaisano Capital Iloilo City Center (ICC)',
    category: 'Mall',
    district: 'Mandurriao',
    coordinates: LatLng(10.7052, 122.5588),
    keywords: ['gaisano', 'icc', 'diversion'],
  ),
  IloiloPlace(
    name: 'Gaisano Capital La Paz',
    category: 'Mall',
    district: 'La Paz',
    coordinates: LatLng(10.7102, 122.5675),
    keywords: ['gaisano la paz', 'luna'],
  ),
  IloiloPlace(
    name: 'The Atrium Mall',
    category: 'Mall',
    district: 'City Proper',
    coordinates: LatLng(10.6996, 122.5675),
    keywords: ['atrium', 'general luna'],
  ),
  IloiloPlace(
    name: 'Marymart Center',
    category: 'Mall',
    district: 'City Proper',
    coordinates: LatLng(10.6956, 122.5688),
    keywords: ['marymart', 'iznart', 'valeria'],
  ),
  IloiloPlace(
    name: 'Plazuela de Iloilo',
    category: 'Mall',
    district: 'Mandurriao',
    coordinates: LatLng(10.7128, 122.5522),
    keywords: ['plazuela', 'diversion'],
  ),
  IloiloPlace(
    name: 'CityMall Parola',
    category: 'Mall',
    district: 'City Proper',
    coordinates: LatLng(10.6948, 122.5762),
    keywords: ['citymall', 'parola', 'guimaras wharf'],
  ),
  IloiloPlace(
    name: 'CityMall Tagbak',
    category: 'Mall',
    district: 'Jaro',
    coordinates: LatLng(10.7495, 122.5718),
    keywords: ['citymall', 'tagbak'],
  ),
  IloiloPlace(
    name: 'S&R Membership Shopping Iloilo',
    category: 'Mall',
    district: 'Mandurriao',
    coordinates: LatLng(10.7095, 122.5535),
    keywords: ['snr', 's&r', 'diversion'],
  ),
  IloiloPlace(
    name: 'SM Delgado',
    category: 'Mall',
    district: 'City Proper',
    coordinates: LatLng(10.6962, 122.5682),
    keywords: ['sm delgado', 'valeria'],
  ),
];

// =============================================================================
// 4. HOSPITALS & MEDICAL CENTERS
// =============================================================================
const List<IloiloPlace> iloiloHospitals = [
  IloiloPlace(
    name: 'Western Visayas Medical Center (WVMC)',
    category: 'Hospital',
    district: 'Mandurriao',
    coordinates: LatLng(10.7158, 122.5405),
    keywords: ['wvmc', 'regional hospital', 'q abeto'],
  ),
  IloiloPlace(
    name: 'West Visayas State University Medical Center (WVSUMC)',
    category: 'Hospital',
    district: 'Jaro',
    coordinates: LatLng(10.7165, 122.5628),
    keywords: ['wvsumc', 'don benito', 'e lopez'],
  ),
  IloiloPlace(
    name: 'Iloilo Mission Hospital',
    category: 'Hospital',
    district: 'Jaro',
    coordinates: LatLng(10.7278, 122.5512),
    keywords: ['mission hospital', 'cpu', 'mission rd'],
  ),
  IloiloPlace(
    name: 'The Medical City Iloilo',
    category: 'Hospital',
    district: 'Molo',
    coordinates: LatLng(10.6995, 122.5488),
    keywords: ['medical city', 'tmc', 'locsin'],
  ),
  IloiloPlace(
    name: "St. Paul's Hospital Iloilo",
    category: 'Hospital',
    district: 'City Proper',
    coordinates: LatLng(10.6999, 122.5665),
    keywords: ['st pauls', 'general luna'],
  ),
  IloiloPlace(
    name: "Iloilo Doctors' Hospital",
    category: 'Hospital',
    district: 'Molo',
    coordinates: LatLng(10.6962, 122.5515),
    keywords: ['doctors', 'idh', 'west avenue', 'timawa'],
  ),
  IloiloPlace(
    name: 'QualiMed Hospital Iloilo',
    category: 'Hospital',
    district: 'Mandurriao',
    coordinates: LatLng(10.7082, 122.5512),
    keywords: ['qualimed', 'atria'],
  ),
  IloiloPlace(
    name: 'Metro Iloilo Hospital and Medical Center',
    category: 'Hospital',
    district: 'Jaro',
    coordinates: LatLng(10.7385, 122.5482),
    keywords: ['metro iloilo', 'metropolis', 'tagbak'],
  ),
  IloiloPlace(
    name: 'Medicus Medical Center',
    category: 'Hospital',
    district: 'Mandurriao',
    coordinates: LatLng(10.7065, 122.5542),
    keywords: ['medicus', 'diversion'],
  ),
  IloiloPlace(
    name: "AMOSUP Seamen's Hospital Iloilo",
    category: 'Hospital',
    district: 'Molo',
    coordinates: LatLng(10.6945, 122.5415),
    keywords: ['seamens', 'amosup', 'molo'],
  ),
];

// =============================================================================
// 5. FIRE STATIONS & EMERGENCY RESPONSE
// =============================================================================
const List<IloiloPlace> iloiloFireStations = [
  IloiloPlace(
    name: 'BFP Iloilo City Central Fire Station',
    category: 'Fire Station',
    district: 'City Proper',
    coordinates: LatLng(10.6992, 122.5686),
    keywords: ['bfp', 'fire station', 'general luna', 'iznart'],
  ),
  IloiloPlace(
    name: 'Jaro Fire Sub-Station',
    category: 'Fire Station',
    district: 'Jaro',
    coordinates: LatLng(10.7258, 122.5578),
    keywords: ['bfp', 'jaro fire', 'jaro plaza'],
  ),
  IloiloPlace(
    name: 'Molo Fire Sub-Station',
    category: 'Fire Station',
    district: 'Molo',
    coordinates: LatLng(10.6962, 122.5448),
    keywords: ['bfp', 'molo fire', 'molo plaza'],
  ),
  IloiloPlace(
    name: 'La Paz Fire Sub-Station',
    category: 'Fire Station',
    district: 'La Paz',
    coordinates: LatLng(10.7108, 122.5695),
    keywords: ['bfp', 'la paz fire', 'la paz plaza'],
  ),
  IloiloPlace(
    name: 'Mandurriao Fire Sub-Station',
    category: 'Fire Station',
    district: 'Mandurriao',
    coordinates: LatLng(10.7202, 122.5362),
    keywords: ['bfp', 'mandurriao fire', 'mandurriao plaza'],
  ),
  IloiloPlace(
    name: 'Arevalo Fire Sub-Station',
    category: 'Fire Station',
    district: 'Arevalo',
    coordinates: LatLng(10.6888, 122.5162),
    keywords: ['bfp', 'arevalo fire', 'villa'],
  ),
  IloiloPlace(
    name: 'Lapuz Fire Sub-Station',
    category: 'Fire Station',
    district: 'Lapuz',
    coordinates: LatLng(10.7012, 122.5812),
    keywords: ['bfp', 'lapuz fire', 'bo obrero'],
  ),
  IloiloPlace(
    name: 'Iloilo City Emergency Responders (ICER) HQ',
    category: 'Fire Station',
    district: 'City Proper',
    coordinates: LatLng(10.6929, 122.5738),
    keywords: ['icer', 'rescue', 'emergency', 'city hall'],
  ),
];

// =============================================================================
// 6. PARKS & PUBLIC PLAZAS
// =============================================================================
const List<IloiloPlace> iloiloParksAndPlazas = [
  IloiloPlace(
    name: 'Jaro Plaza (Graciano Lopez Jaena Park)',
    category: 'Park / Plaza',
    district: 'Jaro',
    coordinates: LatLng(10.7250, 122.5572),
    keywords: ['jaro plaza', 'park'],
  ),
  IloiloPlace(
    name: 'Molo Plaza',
    category: 'Park / Plaza',
    district: 'Molo',
    coordinates: LatLng(10.6968, 122.5446),
    keywords: ['molo plaza', 'park'],
  ),
  IloiloPlace(
    name: 'Plaza Libertad',
    category: 'Park / Plaza',
    district: 'City Proper',
    coordinates: LatLng(10.6927, 122.5734),
    keywords: ['plaza libertad', 'city hall'],
  ),
  IloiloPlace(
    name: 'La Paz Plaza',
    category: 'Park / Plaza',
    district: 'La Paz',
    coordinates: LatLng(10.7104, 122.5692),
    keywords: ['la paz plaza', 'park'],
  ),
  IloiloPlace(
    name: 'Mandurriao Plaza',
    category: 'Park / Plaza',
    district: 'Mandurriao',
    coordinates: LatLng(10.7204, 122.5359),
    keywords: ['mandurriao plaza', 'park'],
  ),
  IloiloPlace(
    name: 'Arevalo Plaza',
    category: 'Park / Plaza',
    district: 'Arevalo',
    coordinates: LatLng(10.6891, 122.5162),
    keywords: ['arevalo plaza', 'villa'],
  ),
  IloiloPlace(
    name: 'Iloilo River Esplanade (Esplanade 1 - Diversion)',
    category: 'Park / Plaza',
    district: 'Mandurriao',
    coordinates: LatLng(10.7038, 122.5558),
    keywords: ['esplanade', 'river', 'walk'],
  ),
  IloiloPlace(
    name: 'Iloilo River Esplanade (Esplanade 2 - Carpenter Bridge)',
    category: 'Park / Plaza',
    district: 'Molo',
    coordinates: LatLng(10.7035, 122.5465),
    keywords: ['esplanade', 'carpenter bridge'],
  ),
  IloiloPlace(
    name: 'Sunburst Park',
    category: 'Park / Plaza',
    district: 'City Proper',
    coordinates: LatLng(10.6936, 122.5736),
    keywords: ['sunburst', 'aduana', 'jm basa'],
  ),
  IloiloPlace(
    name: 'Fort San Pedro Park',
    category: 'Park / Plaza',
    district: 'City Proper',
    coordinates: LatLng(10.6898, 122.5785),
    keywords: ['fort san pedro', 'seafront'],
  ),
  IloiloPlace(
    name: 'Iloilo Freedom Grandstand',
    category: 'Park / Plaza',
    district: 'City Proper',
    coordinates: LatLng(10.6948, 122.5748),
    keywords: ['dinagyang', 'grandstand', 'muelle loney'],
  ),
];

// =============================================================================
// 7. CEMETERIES & MEMORIAL PARKS
// =============================================================================
const List<IloiloPlace> iloiloCemeteries = [
  IloiloPlace(
    name: 'Jaro Catholic Cemetery',
    category: 'Cemetery',
    district: 'Jaro',
    coordinates: LatLng(10.7288, 122.5542),
    keywords: ['jaro cemetery', 'democracia'],
  ),
  IloiloPlace(
    name: 'Christ the King Memorial Park',
    category: 'Cemetery',
    district: 'Jaro',
    coordinates: LatLng(10.7365, 122.5592),
    keywords: ['christ the king', 'memorial', 'buhang'],
  ),
  IloiloPlace(
    name: 'Forest Lake Memorial Park Iloilo',
    category: 'Cemetery',
    district: 'Mandurriao',
    coordinates: LatLng(10.7228, 122.5285),
    keywords: ['forest lake', 'memorial', 'hibao-an'],
  ),
  IloiloPlace(
    name: 'Molo Catholic Cemetery',
    category: 'Cemetery',
    district: 'Molo',
    coordinates: LatLng(10.6985, 122.5418),
    keywords: ['molo cemetery', 'san juan'],
  ),
  IloiloPlace(
    name: 'La Paz Catholic Cemetery',
    category: 'Cemetery',
    district: 'La Paz',
    coordinates: LatLng(10.7138, 122.5702),
    keywords: ['la paz cemetery', 'jalandoni'],
  ),
  IloiloPlace(
    name: 'Iloilo Chinese Cemetery',
    category: 'Cemetery',
    district: 'Molo',
    coordinates: LatLng(10.6978, 122.5405),
    keywords: ['chinese cemetery', 'molo'],
  ),
  IloiloPlace(
    name: 'Arevalo Catholic Cemetery',
    category: 'Cemetery',
    district: 'Arevalo',
    coordinates: LatLng(10.6915, 122.5178),
    keywords: ['arevalo cemetery', 'yulo drive'],
  ),
  IloiloPlace(
    name: 'Tanza Public Cemetery',
    category: 'Cemetery',
    district: 'City Proper',
    coordinates: LatLng(10.6908, 122.5622),
    keywords: ['tanza cemetery', 'bonifacio tanza'],
  ),
];

// =============================================================================
// 8. CHURCHES & SHRINES
// =============================================================================
const List<IloiloPlace> iloiloChurches = [
  IloiloPlace(
    name: 'Jaro Metropolitan Cathedral (Our Lady of the Candles)',
    category: 'Church',
    district: 'Jaro',
    coordinates: LatLng(10.7263, 122.5567),
    keywords: ['jaro cathedral', 'candelaria', 'shrine'],
  ),
  IloiloPlace(
    name: 'St. Anne Parish Church (Molo Church)',
    category: 'Church',
    district: 'Molo',
    coordinates: LatLng(10.6975, 122.5446),
    keywords: ['molo church', 'st anne', 'feminist church'],
  ),
  IloiloPlace(
    name: 'San Jose Placer Parish Church',
    category: 'Church',
    district: 'City Proper',
    coordinates: LatLng(10.6922, 122.5731),
    keywords: ['san jose', 'dinagyang', 'plaza libertad'],
  ),
  IloiloPlace(
    name: 'Parish of Our Lady of Peace and Good Voyage (La Paz Church)',
    category: 'Church',
    district: 'La Paz',
    coordinates: LatLng(10.7102, 122.5685),
    keywords: ['la paz church', 'la paz plaza'],
  ),
  IloiloPlace(
    name: "St. Clement's Church (Redemptorist)",
    category: 'Church',
    district: 'La Paz',
    coordinates: LatLng(10.7115, 122.5648),
    keywords: ['st clements', 'redemptorist', 'luna'],
  ),
  IloiloPlace(
    name: 'Santa Maria Parish Church (Our Lady of China)',
    category: 'Church',
    district: 'City Proper',
    coordinates: LatLng(10.6989, 122.5648),
    keywords: ['santa maria', 'chinese church', 'general luna'],
  ),
  IloiloPlace(
    name: 'Sto. Niño de Arevalo Parish Church',
    category: 'Church',
    district: 'Arevalo',
    coordinates: LatLng(10.6887, 122.5156),
    keywords: ['sto nino', 'arevalo church', 'villa'],
  ),
  IloiloPlace(
    name: 'Espousal of Our Lady Parish (Mandurriao Church)',
    category: 'Church',
    district: 'Mandurriao',
    coordinates: LatLng(10.7206, 122.5354),
    keywords: ['mandurriao church', 'mandurriao plaza'],
  ),
  IloiloPlace(
    name: 'St. Joseph the Worker Parish',
    category: 'Church',
    district: 'Jaro',
    coordinates: LatLng(10.7295, 122.5608),
    keywords: ['st joseph', 'jaro bridge', 'e lopez'],
  ),
  IloiloPlace(
    name: 'Carmelite Monastery of Our Lady',
    category: 'Church',
    district: 'Jaro',
    coordinates: LatLng(10.7265, 122.5598),
    keywords: ['carmelite', 'monastery', 'jaro'],
  ),
];

// =============================================================================
// 9. FAMOUS LANDMARKS & HERITAGE SITES
// =============================================================================
const List<IloiloPlace> iloiloFamousLandmarks = [
  IloiloPlace(
    name: 'Calle Real (JM Basa Heritage Street)',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.6938, 122.5715),
    keywords: ['calle real', 'jm basa', 'heritage'],
  ),
  IloiloPlace(
    name: 'Molo Mansion (Yusay-Consing Mansion)',
    category: 'Landmark',
    district: 'Molo',
    coordinates: LatLng(10.6962, 122.5448),
    keywords: ['molo mansion', 'yusay consing'],
  ),
  IloiloPlace(
    name: 'Casa Mariquit',
    category: 'Landmark',
    district: 'Jaro',
    coordinates: LatLng(10.7256, 122.5592),
    keywords: ['casa mariquit', 'heritage house', 'jaro'],
  ),
  IloiloPlace(
    name: "Nelly's Garden (Lopez Heritage House)",
    category: 'Landmark',
    district: 'Jaro',
    coordinates: LatLng(10.7222, 122.5612),
    keywords: ['nellys garden', 'lopez', 'e lopez'],
  ),
  IloiloPlace(
    name: 'Lizares Mansion',
    category: 'Landmark',
    district: 'Jaro',
    coordinates: LatLng(10.7336, 122.5614),
    keywords: ['lizares mansion', 'tabuc suba'],
  ),
  IloiloPlace(
    name: 'Arroyo Fountain (Kilometer Zero)',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.6995, 122.5684),
    keywords: ['arroyo fountain', 'km 0', 'capitol'],
  ),
  IloiloPlace(
    name: 'Iloilo Convention Center (ICON)',
    category: 'Landmark',
    district: 'Mandurriao',
    coordinates: LatLng(10.7165, 122.5468),
    keywords: ['icon', 'convention center', 'megaworld'],
  ),
  IloiloPlace(
    name: 'Jaro Belfry (Campanario de Jaro)',
    category: 'Landmark',
    district: 'Jaro',
    coordinates: LatLng(10.7254, 122.5568),
    keywords: ['belfry', 'bell tower', 'jaro plaza'],
  ),
  IloiloPlace(
    name: 'Museo Iloilo',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.7002, 122.5692),
    keywords: ['museo iloilo', 'bonifacio'],
  ),
  IloiloPlace(
    name: 'National Museum Western Visayas',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.7005, 122.5696),
    keywords: ['national museum', 'old jail', 'bonifacio'],
  ),
  IloiloPlace(
    name: 'Parola Ferry Wharf (Guimaras Terminal)',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.6948, 122.5768),
    keywords: ['parola', 'guimaras', 'ferry', 'wharf'],
  ),
  IloiloPlace(
    name: 'Ortiz Wharf (Guimaras Pumpboat Terminal)',
    category: 'Landmark',
    district: 'City Proper',
    coordinates: LatLng(10.6908, 122.5752),
    keywords: ['ortiz', 'guimaras', 'wharf'],
  ),
];

// =============================================================================
// 10. GOVERNMENT OFFICES & PUBLIC SERVICES
// =============================================================================
const List<IloiloPlace> iloiloGovernmentOffices = [
  IloiloPlace(
    name: 'Iloilo City Hall',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.6929, 122.5738),
    keywords: ['city hall', 'mayor', 'plaza libertad'],
  ),
  IloiloPlace(
    name: 'Iloilo Provincial Capitol',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.6998, 122.5688),
    keywords: ['capitol', 'governor', 'bonifacio'],
  ),
  IloiloPlace(
    name: 'Chief Justice Ramon Avanceña Hall of Justice',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.7012, 122.5695),
    keywords: ['hall of justice', 'court', 'bonifacio'],
  ),
  IloiloPlace(
    name: 'BIR Revenue District Office No. 74 (Iloilo City)',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.6978, 122.5698),
    keywords: ['bir', 'tax', 'mckinley'],
  ),
  IloiloPlace(
    name: 'DFA Consular Office Iloilo (Robinsons Place)',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.6968, 122.5645),
    keywords: ['dfa', 'passport', 'robinsons'],
  ),
  IloiloPlace(
    name: 'SSS Iloilo Branch',
    category: 'Government',
    district: 'Molo',
    coordinates: LatLng(10.6965, 122.5502),
    keywords: ['sss', 'social security', 'timawa'],
  ),
  IloiloPlace(
    name: 'PhilHealth Regional Office VI',
    category: 'Government',
    district: 'Mandurriao',
    coordinates: LatLng(10.7086, 122.5518),
    keywords: ['philhealth', 'atria'],
  ),
  IloiloPlace(
    name: 'Pag-IBIG Fund Iloilo Member Services Branch',
    category: 'Government',
    district: 'Mandurriao',
    coordinates: LatLng(10.7128, 122.5522),
    keywords: ['pag-ibig', 'pagibig', 'plazuela'],
  ),
  IloiloPlace(
    name: 'LTO Region VI Regional Office',
    category: 'Government',
    district: 'Jaro',
    coordinates: LatLng(10.7355, 122.5562),
    keywords: ['lto', 'license', 'quintin salas'],
  ),
  IloiloPlace(
    name: 'PSA Region VI (Philippine Statistics Authority)',
    category: 'Government',
    district: 'Jaro',
    coordinates: LatLng(10.7278, 122.5595),
    keywords: ['psa', 'nso', 'birth certificate', 'e lopez'],
  ),
  IloiloPlace(
    name: 'DOST Region VI Regional Office',
    category: 'Government',
    district: 'La Paz',
    coordinates: LatLng(10.7135, 122.5642),
    keywords: ['dost', 'science', 'magsaysay village'],
  ),
  IloiloPlace(
    name: 'Iloilo Central Post Office (PHLPost)',
    category: 'Government',
    district: 'City Proper',
    coordinates: LatLng(10.6935, 122.5745),
    keywords: ['post office', 'phlpost', 'aduana'],
  ),
];

// =============================================================================
// 11. FAST FOOD RESTAURANTS & ICONIC ILOILO DINING
// =============================================================================
const List<IloiloPlace> iloiloRestaurants = [
  IloiloPlace(
    name: 'Jollibee Jaro Plaza',
    category: 'Restaurant',
    district: 'Jaro',
    coordinates: LatLng(10.7248, 122.5582),
    keywords: ['jollibee', 'fast food', 'jaro'],
  ),
  IloiloPlace(
    name: 'Jollibee General Luna',
    category: 'Restaurant',
    district: 'City Proper',
    coordinates: LatLng(10.6992, 122.5668),
    keywords: ['jollibee', 'fast food', 'general luna'],
  ),
  IloiloPlace(
    name: 'Jollibee SM City Iloilo',
    category: 'Restaurant',
    district: 'Mandurriao',
    coordinates: LatLng(10.7145, 122.5515),
    keywords: ['jollibee', 'fast food', 'sm city'],
  ),
  IloiloPlace(
    name: 'Jollibee Diversion Road',
    category: 'Restaurant',
    district: 'Mandurriao',
    coordinates: LatLng(10.7115, 122.5528),
    keywords: ['jollibee', 'drive thru', 'diversion'],
  ),
  IloiloPlace(
    name: "McDonald's Jaro Plaza",
    category: 'Restaurant',
    district: 'Jaro',
    coordinates: LatLng(10.7252, 122.5585),
    keywords: ['mcdonalds', 'mcdo', 'fast food', 'jaro'],
  ),
  IloiloPlace(
    name: "McDonald's General Luna",
    category: 'Restaurant',
    district: 'City Proper',
    coordinates: LatLng(10.6994, 122.5655),
    keywords: ['mcdonalds', 'mcdo', 'fast food'],
  ),
  IloiloPlace(
    name: "McDonald's Festive Walk / Megaworld",
    category: 'Restaurant',
    district: 'Mandurriao',
    coordinates: LatLng(10.7178, 122.5462),
    keywords: ['mcdonalds', 'mcdo', 'festive'],
  ),
  IloiloPlace(
    name: 'Mang Inasal Jaro',
    category: 'Restaurant',
    district: 'Jaro',
    coordinates: LatLng(10.7255, 122.5586),
    keywords: ['mang inasal', 'fast food', 'chicken'],
  ),
  IloiloPlace(
    name: 'Chowking Jaro',
    category: 'Restaurant',
    district: 'Jaro',
    coordinates: LatLng(10.7244, 122.5579),
    keywords: ['chowking', 'fast food'],
  ),
  IloiloPlace(
    name: 'KFC Festive Walk',
    category: 'Restaurant',
    district: 'Mandurriao',
    coordinates: LatLng(10.7180, 122.5455),
    keywords: ['kfc', 'fast food'],
  ),
  IloiloPlace(
    name: 'Burger King Diversion Road',
    category: 'Restaurant',
    district: 'Mandurriao',
    coordinates: LatLng(10.7192, 122.5488),
    keywords: ['burger king', 'fast food', 'diversion'],
  ),
  IloiloPlace(
    name: "Roberto's Siopao (Calle Real)",
    category: 'Restaurant',
    district: 'City Proper',
    coordinates: LatLng(10.6939, 122.5712),
    keywords: ['robertos', 'siopao', 'queen siopao', 'jm basa'],
  ),
  IloiloPlace(
    name: "Netong's Original Special La Paz Batchoy",
    category: 'Restaurant',
    district: 'La Paz',
    coordinates: LatLng(10.7114, 122.5698),
    keywords: ['netongs', 'batchoy', 'la paz market'],
  ),
  IloiloPlace(
    name: "Ted's Oldtimer Lapaz Batchoy (La Paz)",
    category: 'Restaurant',
    district: 'La Paz',
    coordinates: LatLng(10.7110, 122.5692),
    keywords: ['teds', 'batchoy', 'la paz'],
  ),
  IloiloPlace(
    name: "Deco's Original La Paz Batchoy",
    category: 'Restaurant',
    district: 'La Paz',
    coordinates: LatLng(10.7112, 122.5695),
    keywords: ['decos', 'batchoy', 'la paz'],
  ),
  IloiloPlace(
    name: "Alicia's Special Batchoy",
    category: 'Restaurant',
    district: 'Jaro',
    coordinates: LatLng(10.7235, 122.5565),
    keywords: ['alicias', 'batchoy', 'washington'],
  ),
  IloiloPlace(
    name: 'Madge Cafe (La Paz Market)',
    category: 'Restaurant',
    district: 'La Paz',
    coordinates: LatLng(10.7114, 122.5699),
    keywords: ['madge cafe', 'coffee', 'kapehan'],
  ),
  IloiloPlace(
    name: "Tatoy's Manokan and Seafoods (Villa Beach)",
    category: 'Restaurant',
    district: 'Arevalo',
    coordinates: LatLng(10.6812, 122.5115),
    keywords: ['tatoys', 'seafood', 'manokan', 'villa beach'],
  ),
  IloiloPlace(
    name: 'Breakthrough Restaurant (Villa Beach)',
    category: 'Restaurant',
    district: 'Arevalo',
    coordinates: LatLng(10.6815, 122.5132),
    keywords: ['breakthrough', 'seafood', 'villa beach'],
  ),
  IloiloPlace(
    name: "Kap Ising's Pancit Molo",
    category: 'Restaurant',
    district: 'Molo',
    coordinates: LatLng(10.6968, 122.5442),
    keywords: ['kap ising', 'pancit molo'],
  ),
];

// =============================================================================
// 12. LEISURE & FUN PLACES
// =============================================================================
const List<IloiloPlace> iloiloLeisurePlaces = [
  IloiloPlace(
    name: 'Smallville Business & Entertainment Complex',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7075, 122.5535),
    keywords: ['smallville', 'nightlife', 'hangout', 'diversion'],
  ),
  IloiloPlace(
    name: 'Atria Park District',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7085, 122.5515),
    keywords: ['atria', 'shops at atria', 'dining'],
  ),
  IloiloPlace(
    name: 'Festive Walk Parade',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7176, 122.5453),
    keywords: ['festive walk parade', 'megaworld', 'nightlife'],
  ),
  IloiloPlace(
    name: 'Villa Beach & Arevalo Boulevard',
    category: 'Leisure',
    district: 'Arevalo',
    coordinates: LatLng(10.6815, 122.5120),
    keywords: ['villa beach', 'beach', 'seafront', 'baybay'],
  ),
  IloiloPlace(
    name: 'Iloilo Sports Complex',
    category: 'Leisure',
    district: 'La Paz',
    coordinates: LatLng(10.7142, 122.5675),
    keywords: ['sports complex', 'oval', 'swimming', 'track'],
  ),
  IloiloPlace(
    name: 'Boardwalk Iloilo (Iloilo River)',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7052, 122.5552),
    keywords: ['boardwalk', 'river', 'esplanade'],
  ),
  IloiloPlace(
    name: 'Waterworld Iloilo',
    category: 'Leisure',
    district: 'Jaro',
    coordinates: LatLng(10.7465, 122.5702),
    keywords: ['waterworld', 'waterpark', 'pool', 'tagbak'],
  ),
  IloiloPlace(
    name: 'Iloilo Museum of Contemporary Art (ILOMOCA)',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7175, 122.5462),
    keywords: ['ilomoca', 'museum', 'art', 'festive'],
  ),
  IloiloPlace(
    name: 'Brandy Museum Iloilo',
    category: 'Leisure',
    district: 'Mandurriao',
    coordinates: LatLng(10.7179, 122.5458),
    keywords: ['brandy museum', 'festive'],
  ),
  IloiloPlace(
    name: 'Camiña Balay nga Bato',
    category: 'Leisure',
    district: 'Arevalo',
    coordinates: LatLng(10.6882, 122.5195),
    keywords: ['camina', 'balay nga bato', 'tsokolate', 'heritage'],
  ),
];

// =============================================================================
// 13. ALL 180 BARANGAYS OF ILOILO CITY (BY DISTRICT)
// =============================================================================
const List<IloiloPlace> iloiloBarangays = [
  // --- AREVALO (13 Barangays) ---
  IloiloPlace(name: 'Barangay Bonifacio', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6895, 122.5155)),
  IloiloPlace(name: 'Barangay Calaparan', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6895, 122.5290)),
  IloiloPlace(name: 'Barangay Dulonan', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6928, 122.5245)),
  IloiloPlace(name: 'Barangay Mohon', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6867, 122.5026)),
  IloiloPlace(name: 'Barangay Quezon', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6882, 122.5142)),
  IloiloPlace(name: 'Barangay San Jose', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6890, 122.5175)),
  IloiloPlace(name: 'Barangay Santa Cruz', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6875, 122.5198)),
  IloiloPlace(name: 'Barangay Santa Filomena', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6912, 122.5125)),
  IloiloPlace(name: 'Barangay Santo Domingo', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6885, 122.5225)),
  IloiloPlace(name: 'Barangay Santo Niño Norte', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6872, 122.5085)),
  IloiloPlace(name: 'Barangay Santo Niño Sur', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6845, 122.5065)),
  IloiloPlace(name: 'Barangay So-oc', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6985, 122.5145)),
  IloiloPlace(name: 'Barangay Yulo Drive', category: 'Barangay', district: 'Arevalo', coordinates: LatLng(10.6918, 122.5182)),

  // --- CITY PROPER (45 Barangays) ---
  IloiloPlace(name: 'Barangay Arsenal Aduana', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6932, 122.5748)),
  IloiloPlace(name: 'Barangay Baybay Tanza', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6892, 122.5648)),
  IloiloPlace(name: 'Barangay Bonifacio Tanza', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6908, 122.5632)),
  IloiloPlace(name: 'Barangay Concepcion-Montes', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6905, 122.5712)),
  IloiloPlace(name: 'Barangay Danao', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6948, 122.5728)),
  IloiloPlace(name: 'Barangay Delgado-Jalandoni-Bagumbayan', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6968, 122.5665)),
  IloiloPlace(name: 'Barangay Edganzon', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6952, 122.5712)),
  IloiloPlace(name: 'Barangay Flores', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6942, 122.5738)),
  IloiloPlace(name: 'Barangay General Hughes-Montes', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6915, 122.5742)),
  IloiloPlace(name: 'Barangay Gloria', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6958, 122.5702)),
  IloiloPlace(name: 'Barangay Hipodromo', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6982, 122.5662)),
  IloiloPlace(name: 'Barangay Inday', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6975, 122.5678)),
  IloiloPlace(name: 'Barangay Jalandoni-Wilson', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6955, 122.5655)),
  IloiloPlace(name: 'Barangay Kahirupan', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6935, 122.5682)),
  IloiloPlace(name: 'Barangay Kauswagan', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6928, 122.5675)),
  IloiloPlace(name: 'Barangay Legaspi dela Rama', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6918, 122.5758)),
  IloiloPlace(name: 'Barangay Liberation', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6925, 122.5725)),
  IloiloPlace(name: 'Barangay Mabolo-Delgado', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6978, 122.5612)),
  IloiloPlace(name: 'Barangay Magsaysay', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6945, 122.5752)),
  IloiloPlace(name: 'Barangay Malipayon', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6922, 122.5652)),
  IloiloPlace(name: 'Barangay Maria Clara', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6985, 122.5688)),
  IloiloPlace(name: 'Barangay Monica Blumentritt', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6912, 122.5698)),
  IloiloPlace(name: 'Barangay Muelle Loney-Montes', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6962, 122.5752)),
  IloiloPlace(name: 'Barangay Nonoy', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6952, 122.5675)),
  IloiloPlace(name: 'Barangay Ortiz', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6912, 122.5748)),
  IloiloPlace(name: 'Barangay Osmeña', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6945, 122.5695)),
  IloiloPlace(name: 'Barangay President Roxas', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6938, 122.5722)),
  IloiloPlace(name: 'Barangay Rima-Rizal', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6928, 122.5688)),
  IloiloPlace(name: 'Barangay Rizal Estanzuela', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6912, 122.5678)),
  IloiloPlace(name: 'Barangay Rizal Ibarra', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6918, 122.5665)),
  IloiloPlace(name: 'Barangay Rizal Palapala I', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6902, 122.5685)),
  IloiloPlace(name: 'Barangay Rizal Palapala II', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6898, 122.5672)),
  IloiloPlace(name: 'Barangay Roxas Village', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6965, 122.5718)),
  IloiloPlace(name: 'Barangay Sampaloc', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6988, 122.5672)),
  IloiloPlace(name: 'Barangay San Agustin', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6992, 122.5625)),
  IloiloPlace(name: 'Barangay San Felix', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6972, 122.5712)),
  IloiloPlace(name: 'Barangay San Jose', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6924, 122.5732)),
  IloiloPlace(name: 'Barangay Santo Rosario-Duran', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6905, 122.5762)),
  IloiloPlace(name: 'Barangay Tanza-Esperanza', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6918, 122.5618)),
  IloiloPlace(name: 'Barangay Timawa Tanza I', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6935, 122.5612)),
  IloiloPlace(name: 'Barangay Timawa Tanza II', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6925, 122.5598)),
  IloiloPlace(name: 'Barangay Veterans Village', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6892, 122.5715)),
  IloiloPlace(name: 'Barangay Villa Anita', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6965, 122.5588)),
  IloiloPlace(name: 'Barangay Yulo-Arroyo', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6948, 122.5708)),
  IloiloPlace(name: 'Barangay Zamora-Melliza', category: 'Barangay', district: 'City Proper', coordinates: LatLng(10.6902, 122.5735)),

  // --- JARO (42 Barangays) ---
  IloiloPlace(name: 'Barangay Arguelles', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7265, 122.5542)),
  IloiloPlace(name: 'Barangay Balabago', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7410, 122.5780)),
  IloiloPlace(name: 'Barangay Balantang', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7495, 122.5625)),
  IloiloPlace(name: 'Barangay Benedicto', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7242, 122.5605)),
  IloiloPlace(name: 'Barangay Bito-on', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7465, 122.5875)),
  IloiloPlace(name: 'Barangay Buhang', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7354, 122.5637)),
  IloiloPlace(name: 'Barangay Buntatala', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7585, 122.5745)),
  IloiloPlace(name: 'Barangay Camalig', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7565, 122.5645)),
  IloiloPlace(name: 'Barangay Claudio Castilla El 98', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7228, 122.5562)),
  IloiloPlace(name: 'Barangay Cuartero', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7248, 122.5522)),
  IloiloPlace(name: 'Barangay Cubay', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7365, 122.5715)),
  IloiloPlace(name: 'Barangay Democracia', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7285, 122.5562)),
  IloiloPlace(name: 'Barangay Desamparados', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7215, 122.5535)),
  IloiloPlace(name: 'Barangay Dungon A', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7282, 122.5485)),
  IloiloPlace(name: 'Barangay Dungon B', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7312, 122.5445)),
  IloiloPlace(name: 'Barangay Fajardo', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7238, 122.5515)),
  IloiloPlace(name: 'Barangay Gran Plains', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7412, 122.5618)),
  IloiloPlace(name: 'Barangay Javellana', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7212, 122.5618)),
  IloiloPlace(name: 'Barangay Lanit', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7545, 122.5555)),
  IloiloPlace(name: 'Barangay Libertad-Santa Isabel', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7245, 122.5548)),
  IloiloPlace(name: 'Barangay Lopez Jaena Norte', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7278, 122.5532)),
  IloiloPlace(name: 'Barangay Lopez Jaena Sur', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7265, 122.5558)),
  IloiloPlace(name: 'Barangay Luna', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7222, 122.5592)),
  IloiloPlace(name: 'Barangay M.V. Hechanova', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7375, 122.5672)),
  IloiloPlace(name: 'Barangay Ma. Cristina', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7272, 122.5578)),
  IloiloPlace(name: 'Barangay Montinola', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7302, 122.5598)),
  IloiloPlace(name: 'Barangay Our Lady of Fatima', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7295, 122.5512)),
  IloiloPlace(name: 'Barangay Our Lady of Lourdes', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7315, 122.5528)),
  IloiloPlace(name: 'Barangay Quintin Salas', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7355, 122.5560)),
  IloiloPlace(name: 'Barangay Sambag', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7346, 122.5458)),
  IloiloPlace(name: 'Barangay San Isidro', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7362, 122.5512)),
  IloiloPlace(name: 'Barangay San Jose', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7258, 122.5585)),
  IloiloPlace(name: 'Barangay San Pedro', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7292, 122.5582)),
  IloiloPlace(name: 'Barangay San Roque', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7262, 122.5568)),
  IloiloPlace(name: 'Barangay San Vicente', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7202, 122.5568)),
  IloiloPlace(name: 'Barangay Seminario', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7235, 122.5572)),
  IloiloPlace(name: 'Barangay Simon Ledesma', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7305, 122.5558)),
  IloiloPlace(name: 'Barangay Tabuc Suba', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7325, 122.5625)),
  IloiloPlace(name: 'Barangay Tacas', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7482, 122.5545)),
  IloiloPlace(name: 'Barangay Tagbak', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7522, 122.5735)),
  IloiloPlace(name: 'Barangay Taytay Zone II', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7275, 122.5592)),
  IloiloPlace(name: 'Barangay Ungka', category: 'Barangay', district: 'Jaro', coordinates: LatLng(10.7429, 122.5361)),

  // --- LA PAZ (25 Barangays) ---
  IloiloPlace(name: 'Barangay Aguinaldo', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7082, 122.5685)),
  IloiloPlace(name: 'Barangay Baldoza', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7135, 122.5745)),
  IloiloPlace(name: 'Barangay Bantud', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7165, 122.5762)),
  IloiloPlace(name: 'Barangay Banuyao', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7195, 122.5785)),
  IloiloPlace(name: 'Barangay Burgos-Mabini-Plaza', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7104, 122.5692)),
  IloiloPlace(name: 'Barangay Caingin', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7152, 122.5712)),
  IloiloPlace(name: 'Barangay Divinagracia', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7095, 122.5705)),
  IloiloPlace(name: 'Barangay Gustilo', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7192, 122.5682)),
  IloiloPlace(name: 'Barangay Hinactacan', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7265, 122.5845)),
  IloiloPlace(name: 'Barangay Ingore', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7215, 122.5895)),
  IloiloPlace(name: 'Barangay Jereos', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7225, 122.5635)),
  IloiloPlace(name: 'Barangay Laguda', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7075, 122.5672)),
  IloiloPlace(name: 'Barangay Lopez Jaena Norte', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7168, 122.5642)),
  IloiloPlace(name: 'Barangay Lopez Jaena Sur', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7155, 122.5655)),
  IloiloPlace(name: 'Barangay Luna', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7125, 122.5652)),
  IloiloPlace(name: 'Barangay MacArthur', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7088, 122.5715)),
  IloiloPlace(name: 'Barangay Magdalo', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7118, 122.5682)),
  IloiloPlace(name: 'Barangay Magsaysay Village', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7145, 122.5612)),
  IloiloPlace(name: 'Barangay Nabitasan', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7095, 122.5625)),
  IloiloPlace(name: 'Barangay Railway', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7175, 122.5665)),
  IloiloPlace(name: 'Barangay Rizal', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7068, 122.5692)),
  IloiloPlace(name: 'Barangay San Isidro', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7212, 122.5715)),
  IloiloPlace(name: 'Barangay San Nicolas', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7102, 122.5668)),
  IloiloPlace(name: 'Barangay Tabuc Suba', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7245, 122.5662)),
  IloiloPlace(name: 'Barangay Ticud', category: 'Barangay', district: 'La Paz', coordinates: LatLng(10.7128, 122.5724)),

  // --- LAPUZ (12 Barangays) ---
  IloiloPlace(name: 'Barangay Alalasan', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7042, 122.5735)),
  IloiloPlace(name: 'Barangay Bo. Obrero', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.6978, 122.5853)),
  IloiloPlace(name: 'Barangay Don Esteban', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7032, 122.5762)),
  IloiloPlace(name: 'Barangay Jalandoni Estate', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7058, 122.5775)),
  IloiloPlace(name: 'Barangay Lapuz Norte', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7045, 122.5802)),
  IloiloPlace(name: 'Barangay Lapuz Sur', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7005, 122.5795)),
  IloiloPlace(name: 'Barangay Libertad', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7025, 122.5748)),
  IloiloPlace(name: 'Barangay Loboc', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7015, 122.5912)),
  IloiloPlace(name: 'Barangay Mansaya', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.6988, 122.5825)),
  IloiloPlace(name: 'Barangay Progreso', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7038, 122.5842)),
  IloiloPlace(name: 'Barangay Punong', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7052, 122.5755)),
  IloiloPlace(name: 'Barangay Sinikway', category: 'Barangay', district: 'Lapuz', coordinates: LatLng(10.7068, 122.5825)),

  // --- MANDURRIAO (18 Barangays) ---
  IloiloPlace(name: 'Barangay Abeto Mirasol Taft South', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7155, 122.5398)),
  IloiloPlace(name: 'Barangay Airport', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7135, 122.5435)),
  IloiloPlace(name: 'Barangay Bakhaw', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7165, 122.5495)),
  IloiloPlace(name: 'Barangay Bolilao', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7152, 122.5468)),
  IloiloPlace(name: 'Barangay Buhang Taft North', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7185, 122.5382)),
  IloiloPlace(name: 'Barangay Calahunan', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7115, 122.5245)),
  IloiloPlace(name: 'Barangay Dungon C', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7275, 122.5425)),
  IloiloPlace(name: 'Barangay Guzman-Jesena', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7215, 122.5335)),
  IloiloPlace(name: 'Barangay Hibao-an Norte', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7255, 122.5255)),
  IloiloPlace(name: 'Barangay Hibao-an Sur', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7215, 122.5265)),
  IloiloPlace(name: 'Barangay Navais', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7075, 122.5345)),
  IloiloPlace(name: 'Barangay Oñate de Leon', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7195, 122.5368)),
  IloiloPlace(name: 'Barangay Pale Benedicto Rizal', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7222, 122.5348)),
  IloiloPlace(name: 'Barangay PHHC Block 17', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7228, 122.5395)),
  IloiloPlace(name: 'Barangay PHHC Block 22 NHA', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7235, 122.5418)),
  IloiloPlace(name: 'Barangay San Rafael', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7105, 122.5485)),
  IloiloPlace(name: 'Barangay Santa Rosa', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7255, 122.5385)),
  IloiloPlace(name: 'Barangay Tabucan', category: 'Barangay', district: 'Mandurriao', coordinates: LatLng(10.7145, 122.5422)),

  // --- MOLO (25 Barangays) ---
  IloiloPlace(name: 'Barangay Boulevard', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6885, 122.5465)),
  IloiloPlace(name: 'Barangay Calumpang', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6915, 122.5312)),
  IloiloPlace(name: 'Barangay Cochero', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6948, 122.5355)),
  IloiloPlace(name: 'Barangay Compania', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6925, 122.5380)),
  IloiloPlace(name: 'Barangay East Baluarte', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6895, 122.5525)),
  IloiloPlace(name: 'Barangay East Timawa', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6968, 122.5542)),
  IloiloPlace(name: 'Barangay Habog-Habog Salvacion', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6912, 122.5442)),
  IloiloPlace(name: 'Barangay Infante', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6995, 122.5565)),
  IloiloPlace(name: 'Barangay Kasingkasing', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6942, 122.5462)),
  IloiloPlace(name: 'Barangay Katilingban', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6955, 122.5472)),
  IloiloPlace(name: 'Barangay North Avanceña', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6985, 122.5475)),
  IloiloPlace(name: 'Barangay North Baluarte', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6915, 122.5495)),
  IloiloPlace(name: 'Barangay North Fundidor', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6952, 122.5395)),
  IloiloPlace(name: 'Barangay North San Jose', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6982, 122.5432)),
  IloiloPlace(name: 'Barangay Poblacion Molo', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6968, 122.5446)),
  IloiloPlace(name: 'Barangay San Antonio', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6945, 122.5425)),
  IloiloPlace(name: 'Barangay San Juan', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6939, 122.5367)),
  IloiloPlace(name: 'Barangay San Pedro', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.7005, 122.5438)),
  IloiloPlace(name: 'Barangay South Baluarte', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6885, 122.5495)),
  IloiloPlace(name: 'Barangay South Fundidor', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6918, 122.5405)),
  IloiloPlace(name: 'Barangay South San Jose', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6962, 122.5428)),
  IloiloPlace(name: 'Barangay Taal', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6975, 122.5492)),
  IloiloPlace(name: 'Barangay Tap-oc', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6988, 122.5515)),
  IloiloPlace(name: 'Barangay West Habog-Habog', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6902, 122.5425)),
  IloiloPlace(name: 'Barangay West Timawa', category: 'Barangay', district: 'Molo', coordinates: LatLng(10.6962, 122.5515)),
];

// =============================================================================
// MASTER SEARCHABLE LIST (COMBINE ALL CATEGORIES)
// =============================================================================
final List<IloiloPlace> allIloiloPlaces = [
  ...iloiloSchools,
  ...iloiloMarkets,
  ...iloiloMalls,
  ...iloiloHospitals,
  ...iloiloFireStations,
  ...iloiloParksAndPlazas,
  ...iloiloCemeteries,
  ...iloiloChurches,
  ...iloiloFamousLandmarks,
  ...iloiloGovernmentOffices,
  ...iloiloRestaurants,
  ...iloiloLeisurePlaces,
  ...iloiloBarangays,
];

/// Searches across name, keywords/abbreviations, category, and district
List<IloiloPlace> searchIloiloPlaces(String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return [];

  final List<IloiloPlace> startsWithMatches = [];
  final List<IloiloPlace> nameContainsMatches = [];
  final List<IloiloPlace> secondaryMatches = [];

  for (final place in allIloiloPlaces) {
    final nameLower = place.name.toLowerCase();
    final categoryLower = place.category.toLowerCase();
    final districtLower = place.district.toLowerCase();
    final keywordMatch = place.keywords.any((k) => k.toLowerCase().contains(q));

    if (nameLower.startsWith(q) ||
        nameLower.startsWith('barangay $q') ||
        place.keywords.any((k) => k.toLowerCase().startsWith(q))) {
      startsWithMatches.add(place);
    } else if (nameLower.contains(q) || keywordMatch) {
      nameContainsMatches.add(place);
    } else if (categoryLower.contains(q) || districtLower.contains(q)) {
      secondaryMatches.add(place);
    }
  }

  return [
    ...startsWithMatches,
    ...nameContainsMatches,
    ...secondaryMatches,
  ].take(25).toList();
}