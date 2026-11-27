import 'package:material_ui/material_ui.dart';
import 'logged_out_profile_page.dart';
import 'profile_page.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isAgreed = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleDelete() {
    if (!_isAgreed) return;

    // 1. Switch app state back to logged-out and clear saved profile details
    isLoggedInNotifier.value = false;
    userProfileNotifier.value = const UserProfile(
      name: '',
      age: '',
      occupation: '',
      address: '',
    );

    debugPrint('Account deleted. Reason: ${_reasonController.text}');

    // 2. Close DeleteAccountPage, SettingsPage, and ProfilePage to return to main.dart
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. DELETE ACCOUNT HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/settings_page/delete/delete_header.png',
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

            // 2. MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // --- REASON SECTION ---
                    Image.asset(
                      'assets/settings_page/delete/reason_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0xFF22848C),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _reasonController,
                          minLines: 4,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter your reason here...',
                            hintStyle: TextStyle(color: Colors.black38),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // --- AGREE TO DELETE SECTION ---
                    Stack(
                      children: [
                        Image.asset(
                          'assets/settings_page/delete/agree_section.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),

                        // CHECKBOX OVERLAY (Aligned with "AGREE & CONFIRM")
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Align(
                              alignment: const Alignment(-1.0, 0.58),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAgreed = !_isAgreed;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: _isAgreed
                                          ? const Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Color(0xFF22848C),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 120, height: 28),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // RED DELETE BUTTON OVERLAY (Bottom-Right)
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: GestureDetector(
                            onTap: _isAgreed ? _handleDelete : null,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _isAgreed ? 1.0 : 0.45,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF0000),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'DELETE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}