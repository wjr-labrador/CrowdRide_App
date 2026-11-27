import 'dart:typed_data';
import 'package:material_ui/material_ui.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';

class UserProfile {
  final String name;
  final String age;
  final String occupation;
  final String address;
  final Uint8List? photoBytes;

  const UserProfile({
    required this.name,
    required this.age,
    required this.occupation,
    required this.address,
    this.photoBytes,
  });
}

final ValueNotifier<UserProfile> userProfileNotifier =
    ValueNotifier<UserProfile>(
  const UserProfile(
    name: '',
    age: '',
    occupation: '',
    address: '',
  ),
);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

            // 2. SAVED PROFILE CONTENT
            Expanded(
              child: ValueListenableBuilder<UserProfile>(
                valueListenable: userProfileNotifier,
                builder: (context, profile, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        // CIRCULAR PROFILE PICTURE
                        CircleAvatar(
                          radius: 85,
                          backgroundColor: const Color(0xFFE0E0E0),
                          backgroundImage: profile.photoBytes != null
                              ? MemoryImage(profile.photoBytes!)
                              : null,
                          child: profile.photoBytes == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        const SizedBox(height: 24),

                        // NAME CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B6770),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _buildInfoRow(
                            label: 'NAME',
                            value: profile.name,
                            labelWidth: 62,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // AGE, OCCUPATION, ADDRESS CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B6770),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                label: 'AGE',
                                value: profile.age,
                                labelWidth: 105,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                label: 'OCCUPATION',
                                value: profile.occupation,
                                labelWidth: 105,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                label: 'ADDRESS',
                                value: profile.address,
                                labelWidth: 105,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // EDIT PROFILE BUTTON
                        _buildPngButton(
                          assetPath:
                              'assets/profile_page/edit_profile_button.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // SETTINGS BUTTON
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required double labelWidth,
  }) {
    return Row(
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 32,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              value.isEmpty ? '-' : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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