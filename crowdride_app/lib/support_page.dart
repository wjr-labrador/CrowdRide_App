import 'package:material_ui/material_ui.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSend() {
    debugPrint(
      'Support message sent | Email: ${_emailController.text} | Message: ${_messageController.text}',
    );
    Navigator.pop(context); // Returns to settings_page.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. SUPPORT HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/settings_page/support/support_header.png',
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

            // 2. REPORT A BUG / SUGGESTIONS FORM
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // ORANGE HEADER IMAGE
                    Image.asset(
                      'assets/settings_page/support/report_suggest_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),

                    // TEAL CONTAINER BELOW HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF22848C),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // EXPANDING MESSAGE TEXT BOX
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _messageController,
                              minLines: 6, // Initial box height
                              maxLines: null, // Expands as text overflows
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Describe a bug or suggestion...',
                                hintStyle: TextStyle(color: Colors.black38),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // E-MAIL LABEL + INPUT FIELD
                          Row(
                            children: [
                              const Text(
                                'E-MAIL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // ORANGE SEND BUTTON (Bottom-Right)
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _handleSend,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7941D),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SEND',
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
                        ],
                      ),
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