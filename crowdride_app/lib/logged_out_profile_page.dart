import 'package:material_ui/material_ui.dart';
import 'create_profile_page.dart';
import 'settings_page.dart';

// Starts false so the app opens on LoggedOutProfilePage until a profile is created
final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

class LoggedOutProfilePage extends StatelessWidget {
  const LoggedOutProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. PROFILE HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/profile_page/profile_header.png',
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
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            // 2. LOGGED-OUT OPTIONS (Create Profile & Settings)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildPngButton(
                      assetPath: 'assets/profile_page/create_button.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateProfilePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildPngButton(
                      assetPath: 'assets/profile_page/settings_button.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPngButton({
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}