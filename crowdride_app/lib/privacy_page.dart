import 'package:material_ui/material_ui.dart';

/// Shared state controlled by PrivacyPage and read by MapScreen's locate button
final ValueNotifier<bool> locationEnabledNotifier = ValueNotifier<bool>(true);

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. PRIVACY HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/settings_page/privacy/privacy_header.png',
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

            // 2. PRIVACY SETTINGS BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: locationEnabledNotifier,
                  builder: (context, isLocationEnabled, _) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22848C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LOCATION ACCESS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Allow CrowdRide to center on your live GPS position when tapping the locate button.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Switch(
                            value: isLocationEnabled,
                            activeThumbColor: const Color(0xFFF7941D),
                            onChanged: (val) {
                              locationEnabledNotifier.value = val;
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}