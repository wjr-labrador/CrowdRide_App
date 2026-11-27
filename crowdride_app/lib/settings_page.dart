import 'package:material_ui/material_ui.dart';
import 'appearance_display_page.dart';
import 'delete_account_page.dart';
import 'logged_out_profile_page.dart';
import 'offline_page.dart';
import 'privacy_page.dart';
import 'support_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. SETTINGS HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/settings_page/settings_header.png',
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

            // 2. SETTINGS OPTIONS
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: isLoggedInNotifier,
                builder: (context, isLoggedIn, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        _buildPngButton(
                          assetPath:
                              'assets/settings_page/appearance_display_button.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AppearanceDisplayPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildPngButton(
                          assetPath: 'assets/settings_page/privacy_button.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildPngButton(
                          assetPath: 'assets/settings_page/offline_button.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OfflinePage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildPngButton(
                          assetPath: 'assets/settings_page/support_button.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupportPage(),
                              ),
                            );
                          },
                        ),

                        // Only visible when the user has created/signed into a profile
                        if (isLoggedIn) ...[
                          const SizedBox(height: 12),
                          _buildPngButton(
                            assetPath:
                                'assets/settings_page/delete_account_profile.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DeleteAccountPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
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