import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  final _expectedController = TextEditingController();
  final _actualController = TextEditingController();
  
  String _selectedBugType = 'App Crash';
  String _selectedSeverity = 'Medium';
  String _selectedFrequency = 'Sometimes';
  List<File> _attachedImages = [];
  bool _isSubmitting = false;

  final List<String> _bugTypes = [
    'App Crash',
    'Login Issues',
    'Payment Problems',
    'Search Not Working',
    'Images Not Loading',
    'Slow Performance',
    'UI/Display Issues',
    'Notification Problems',
    'Cart Issues',
    'Profile/Settings',
    'Messaging Problems',
    'Other',
  ];

  final List<String> _severityLevels = [
    'Low',
    'Medium', 
    'High',
    'Critical',
  ];

  final List<String> _frequencyOptions = [
    'Always',
    'Often',
    'Sometimes',
    'Rarely',
    'Once',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Report a Bug',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBugDetailsSection(),
              const SizedBox(height: 24),
              _buildDescriptionSection(),
              const SizedBox(height: 24),
              _buildStepsSection(),
              const SizedBox(height: 24),
              _buildExpectedActualSection(),
              const SizedBox(height: 24),
              _buildAttachmentsSection(),
              const SizedBox(height: 24),
              _buildDeviceInfoSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withOpacity(0.1),
            AppColors.error.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bug_report,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Found a Bug?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Help us improve the app',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your bug reports help us make Arc Vest better for everyone. Please provide as much detail as possible so we can quickly identify and fix the issue.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBugDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bug Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: 'Bug Title',
              hint: 'Brief description of the issue',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bug title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Bug Type',
              value: _selectedBugType,
              items: _bugTypes,
              onChanged: (value) => setState(() => _selectedBugType = value!),
              icon: Icons.category_outlined,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Severity',
                    value: _selectedSeverity,
                    items: _severityLevels,
                    onChanged: (value) => setState(() => _selectedSeverity = value!),
                    icon: Icons.priority_high,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Frequency',
                    value: _selectedFrequency,
                    items: _frequencyOptions,
                    onChanged: (value) => setState(() => _selectedFrequency = value!),
                    icon: Icons.repeat,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Detailed Description',
              hint: 'Describe what happened in detail...',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the bug';
                }
                if (value.length < 20) {
                  return 'Please provide more details (at least 20 characters)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Steps to Reproduce',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us reproduce the bug by listing the exact steps',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _stepsController,
              label: 'Steps',
              hint: '1. Open the app\n2. Go to...\n3. Tap on...\n4. Bug occurs',
              icon: Icons.list_alt,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide steps to reproduce the bug';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectedActualSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expected vs Actual Behavior',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _expectedController,
              label: 'Expected Behavior',
              hint: 'What should have happened?',
              icon: Icons.check_circle_outline,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the expected behavior';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _actualController,
              label: 'Actual Behavior',
              hint: 'What actually happened?',
              icon: Icons.error_outline,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the actual behavior';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Screenshots',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate, size: 18),
                  label: const Text('Add Photo'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Screenshots help us understand the issue better',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            if (_attachedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _attachedImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.divider.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 24,
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No screenshots added',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withOpacity(0.6),
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

  Widget _buildDeviceInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This information is automatically collected to help us debug',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            _buildDeviceInfoItem('Device', 'iPhone 14 Pro'),
            _buildDeviceInfoItem('OS Version', 'iOS 17.1'),
            _buildDeviceInfoItem('App Version', '1.2.3'),
            _buildDeviceInfoItem('Network', 'WiFi'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitBugReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Bug Report',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Tips for Better Bug Reports',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('Be specific about what you were trying to do'),
            _buildTip('Include screenshots if the bug affects the UI'),
            _buildTip('Mention if the bug happens consistently or randomly'),
            _buildTip('Note any error messages you see'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _attachedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  void _submitBugReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isSubmitting = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bug report submitted successfully! We\'ll investigate and get back to you.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _stepsController.clear();
        _expectedController.clear();
        _actualController.clear();
        setState(() {
          _selectedBugType = 'App Crash';
          _selectedSeverity = 'Medium';
          _selectedFrequency = 'Sometimes';
          _attachedImages.clear();
        });
      }
    }
  }
}
