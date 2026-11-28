# CrowdRide (`crowdride_app`)

**CrowdRide** is a Flutter mobile transit and map companion built for **Iloilo City** commuters, integrating interactive map layers, all 25 Iloilo City ELPTRP routes with OpenStreetMap/OSRM road alignment, road-clipped trip segment highlighting, landmark and barangay search, local profile persistence, and privacy-aware GPS location centering.

---

## Key Features

* **Splash & Launcher Branding:** Displays `assets/logo.png` for `670 ms` (`0.67s`) on startup before transitioning to the main map screen, paired with Android launcher icons generated via `flutter_launcher_icons`.
* **3-Layer Iloilo City Map (`crowd_ride_map.dart`):**
* **Plain:** Interactive pan-and-zoom view of `assets/map/map.jpg`.
* **Routes:** OpenStreetMap tile rendering (`flutter_map` + `latlong2`) with 25 road-aligned ELPTRP routes, start/end badges, and road-clipped **From → Destination** trip segment highlighting.
* **Traffic:** Time-reactive traffic severity overlay across shared Iloilo City road corridors.


* **Map Controls & GPS Centering:** Smooth animated camera panning, zoom in/out controls, **Face North** rotation reset (`0°`), and privacy-gated GPS centering (`geolocator` + `locationEnabledNotifier`) bounded to Iloilo City.
* **Landmark, Barangay & Route Search (`iloilo_places.dart`, `iloilo_routes.dart`, `route_page.dart`):** Search Iloilo City schools, markets, malls, hospitals, fire stations, plazas, cemeteries, churches, heritage landmarks, government offices, dining spots, leisure sites, and barangays, or plan trips with **From** and **Destination** inputs, fare ranges (`₱15.00` base fare), and route tracking preview.
* **Local Profile & Photo Upload (`profile_page.dart`, `create_profile_page.dart`, `edit_profile_page.dart`):** Create, edit, and persist profile details (name, age, occupation, address, login state, and profile photo bytes) locally on device via `shared_preferences` and `image_picker`.

---

## Project Structure

```text
├── assets/
│   ├── buttons/            # Map & bottom navigation button assets (incl. indicator.png)
│   ├── create_profile/     # Create profile header, edit badge & action buttons
│   ├── edit_profile/       # Edit profile header & save button
│   ├── map/                # Plain map asset (map.jpg)
│   ├── profile_page/       # Profile header & action buttons
│   ├── route_page/         # Route header, price container & track button
│   ├── settings_page/      # Settings & sub-page assets
│   └── logo.png            # App logo & splash screen artwork
├── lib/
│   ├── main.dart           # App entry point, storage init, MapScreen & SafeArea HUD
│   ├── splash_screen.dart  # 0.67s logo splash screen
│   ├── crowd_ride_map.dart # Map controller, layers, trip highlight & north reset
│   ├── iloilo_places.dart  # Iloilo City places, barangays & search helper
│   ├── iloilo_routes.dart  # 25 ELPTRP routes, road corridors, fares & sub-path clipping
│   ├── route_page.dart     # From/Destination route finder, fare sheet & tracker
│   ├── profile_page.dart   # UserProfile model, LocalAccountStorage & ProfilePage
│   ├── create_profile_page.dart
│   ├── edit_profile_page.dart
│   ├── logged_out_profile_page.dart
│   ├── settings_page.dart
│   ├── appearance_display_page.dart
│   ├── privacy_page.dart
│   └── offline_page.dart / delete_account_page.dart / support_page.dart
└── pubspec.yaml

