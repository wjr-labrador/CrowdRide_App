import 'package:material_ui/material_ui.dart';

// Global notifier for the 5 font size levels (0 = Smallest, 2 = Default, 4 = Largest)
final ValueNotifier<int> appFontLevelNotifier = ValueNotifier<int>(2);

const List<double> appFontScales = [0.85, 0.92, 1.0, 1.12, 1.25];

class AppearanceDisplayPage extends StatefulWidget {
  const AppearanceDisplayPage({super.key});

  @override
  State<AppearanceDisplayPage> createState() => _AppearanceDisplayPageState();
}

class _AppearanceDisplayPageState extends State<AppearanceDisplayPage> {
  bool _isThemeExpanded = false;
  bool _isFontExpanded = false;
  int _selectedThemeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/settings_page/appearance_display/appearance_display_header.png',
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

            // 2. EXPANDABLE OPTIONS
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    // --- THEME SECTION ---
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isThemeExpanded = !_isThemeExpanded;
                        });
                      },
                      child: Image.asset(
                        'assets/settings_page/appearance_display/theme_button.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: _isThemeExpanded
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF22848C),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(4, (index) {
                                  final isSelected =
                                      _selectedThemeIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedThemeIndex = index;
                                      });
                                      debugPrint(
                                          'Theme placeholder ${index + 1} selected');
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(
                                                    color: Colors.orangeAccent,
                                                    width: 3,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'THEME',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 14),

                    // --- FONT SIZE SECTION ---
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFontExpanded = !_isFontExpanded;
                        });
                      },
                      child: Image.asset(
                        'assets/settings_page/appearance_display/font_button.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: _isFontExpanded
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF22848C),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              child: ValueListenableBuilder<int>(
                                valueListenable: appFontLevelNotifier,
                                builder: (context, level, _) {
                                  return Row(
                                    children: [
                                      const Text(
                                        'Aa',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            activeTrackColor: Colors.black,
                                            inactiveTrackColor: Colors.white,
                                            thumbColor: Colors.black,
                                            overlayColor: Colors.black12,
                                            trackHeight: 4.0,
                                            tickMarkShape: SliderTickMarkShape
                                                .noTickMark,
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                              enabledThumbRadius: 6.5,
                                            ),
                                          ),
                                          child: Slider(
                                            value: level.toDouble(),
                                            min: 0,
                                            max: 4,
                                            divisions: 4, // 5 levels (0 to 4)
                                            onChanged: (newValue) {
                                              appFontLevelNotifier.value =
                                                  newValue.round();
                                            },
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Aa',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
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