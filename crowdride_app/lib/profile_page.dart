import 'dart:convert';
import 'dart:typed_data';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import 'logged_out_profile_page.dart';
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

/// Local device storage helper for saving and restoring the user's CrowdRide profile
class LocalAccountStorage {
  static const String _kLoggedIn = 'crowdride_is_logged_in';
  static const String _kName = 'crowdride_profile_name';
  static const String _kAge = 'crowdride_profile_age';
  static const String _kOccupation = 'crowdride_profile_occupation';
  static const String _kAddress = 'crowdride_profile_address';
  static const String _kPhotoBase64 = 'crowdride_profile_photo_b64';

  static bool _listenersAttached = false;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLoggedIn = prefs.getBool(_kLoggedIn) ?? false;
    final name = prefs.getString(_kName) ?? '';
    final age = prefs.getString(_kAge) ?? '';
    final occupation = prefs.getString(_kOccupation) ?? '';
    final address = prefs.getString(_kAddress) ?? '';
    final photoB64 = prefs.getString(_kPhotoBase64);

    Uint8List? bytes;
    if (photoB64 != null && photoB64.isNotEmpty) {
      try {
        bytes = base64Decode(photoB64);
      } catch (_) {}
    }

    isLoggedInNotifier.value = savedLoggedIn;
    userProfileNotifier.value = UserProfile(
      name: name,
      age: age,
      occupation: occupation,
      address: address,
      photoBytes: bytes,
    );

    if (!_listenersAttached) {
      _listenersAttached = true;
      userProfileNotifier.addListener(_persistAll);
      isLoggedInNotifier.addListener(_persistAll);
    }
  }

  static Future<void> _persistAll() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = userProfileNotifier.value;
    final loggedIn = isLoggedInNotifier.value;

    await prefs.setBool(_kLoggedIn, loggedIn);
    await prefs.setString(_kName, profile.name);
    await prefs.setString(_kAge, profile.age);
    await prefs.setString(_kOccupation, profile.occupation);
    await prefs.setString(_kAddress, profile.address);

    if (profile.photoBytes != null && profile.photoBytes!.isNotEmpty) {
      await prefs.setString(_kPhotoBase64, base64Encode(profile.photoBytes!));
    } else {
      await prefs.remove(_kPhotoBase64);
    }
  }

  static Future<void> clearAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLoggedIn);
    await prefs.remove(_kName);
    await prefs.remove(_kAge);
    await prefs.remove(_kOccupation);
    await prefs.remove(_kAddress);
    await prefs.remove(_kPhotoBase64);
  }
}

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