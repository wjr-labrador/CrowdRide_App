import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'logged_out_profile_page.dart';
import 'profile_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  static const List<String> _occupations = [
    'Student',
    'Employed',
    'Unemployed',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  late final PageController _agePageController;

  int _selectedAge = 20;
  String _selectedOccupation = 'Student';
  Uint8List? _selectedPhotoBytes;

  @override
  void initState() {
    super.initState();
    _agePageController = PageController(
      initialPage: _selectedAge,
      viewportFraction: 0.34,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _agePageController.dispose();
    super.dispose();
  }

  void _stepAge(int delta) {
    final target = (_selectedAge + delta).clamp(0, 100);
    if (target == _selectedAge) return;
    _agePageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _pickProfilePhoto(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (mounted) {
        setState(() {
          _selectedPhotoBytes = bytes;
        });
      }
    } catch (_) {
      // Ignore if cancelled or camera unavailable
    }
  }

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF6F4EE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF2B6770),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickProfilePhoto(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF2B6770),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickProfilePhoto(ImageSource.camera);
                  },
                ),
                if (_selectedPhotoBytes != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFD50000),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD50000),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        _selectedPhotoBytes = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCreate() {
    userProfileNotifier.value = UserProfile(
      name: _nameController.text.trim(),
      age: '$_selectedAge Years Old',
      occupation: _selectedOccupation,
      address: _addressController.text.trim(),
      photoBytes: _selectedPhotoBytes,
    );
    isLoggedInNotifier.value = true;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      body: SafeArea(
        child: Column(
          children: [
            // 1. CREATE PROFILE HEADER (with clickable back arrow on the left)
            Stack(
              children: [
                Image.asset(
                  'assets/create_profile/create_profile_header.png',
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

            // 2. FORM CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // CLICKABLE PROFILE PICTURE + EDIT BUTTON
                    GestureDetector(
                      onTap: _showPhotoPickerOptions,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 85,
                            backgroundColor: const Color(0xFFE0E0E0),
                            backgroundImage: _selectedPhotoBytes != null
                                ? MemoryImage(_selectedPhotoBytes!)
                                : null,
                            child: _selectedPhotoBytes == null
                                ? const Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: Colors.black54,
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Image.asset(
                              'assets/create_profile/edit_button.png',
                              width: 44,
                              height: 44,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // NAME CONTAINER
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
                      child: _buildTextInputRow(
                        label: 'NAME',
                        controller: _nameController,
                        labelWidth: 62,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // AGE (0-100 SWIPER), OCCUPATION (DROPDOWN), ADDRESS CONTAINER
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
                          _buildAgeSwiperRow(),
                          const SizedBox(height: 12),
                          _buildOccupationDropdownRow(),
                          const SizedBox(height: 12),
                          _buildTextInputRow(
                            label: 'ADDRESS',
                            controller: _addressController,
                            labelWidth: 80,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // CREATE BUTTON
                    GestureDetector(
                      onTap: _handleCreate,
                      child: Image.asset(
                        'assets/create_profile/create_profile_button.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
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

  Widget _buildAgeSwiperRow() {
    return Row(
      children: [
        const SizedBox(
          width: 62,
          child: Text(
            'AGE',
            style: TextStyle(
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _stepAge(-1),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.chevron_left,
                      size: 20,
                      color: Color(0xFF2B6770),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _agePageController,
                    itemCount: 101,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedAge = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedAge;
                      return GestureDetector(
                        onTap: () => _agePageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        ),
                        child: Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: isSelected ? 14 : 12,
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.black87
                                  : Colors.black38,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => _stepAge(1),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Color(0xFF2B6770),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOccupationDropdownRow() {
    return Row(
      children: [
        const SizedBox(
          width: 105,
          child: Text(
            'OCCUPATION',
            style: TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedOccupation,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF2B6770),
                ),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                ),
                items: _occupations.map((String occupation) {
                  return DropdownMenuItem<String>(
                    value: occupation,
                    child: Text(occupation),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedOccupation = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInputRow({
    required String label,
    required TextEditingController controller,
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}