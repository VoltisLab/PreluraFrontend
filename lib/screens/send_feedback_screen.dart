import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({super.key});

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedFeedbackType = 'General Feedback';
  double _overallRating = 4.0;
  double _easeOfUseRating = 4.0;
  double _featuresRating = 4.0;
  double _performanceRating = 4.0;
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  
  late AnimationController _ratingAnimationController;
  late Animation<double> _ratingAnimation;

  final List<String> _feedbackTypes = [
    'General Feedback',
    'Feature Request',
    'Improvement Suggestion',
    'User Experience',
    'Performance Issue',
    'Design Feedback',
    'Content Suggestion',
    'Vendor Experience',
    'App Store Review',
    'Other',
  ];

  final List<Map<String, dynamic>> _quickFeedbackOptions = [
    {'emoji': '😍', 'text': 'Love it!', 'rating': 5.0},
    {'emoji': '👍', 'text': 'Good app', 'rating': 4.0},
    {'emoji': '😊', 'text': 'Pretty nice', 'rating': 4.0},
    {'emoji': '😐', 'text': 'It\'s okay', 'rating': 3.0},
    {'emoji': '👎', 'text': 'Could be better', 'rating': 2.0},
    {'emoji': '😞', 'text': 'Not great', 'rating': 1.0},
  ];

  @override
  void initState() {
    super.initState();
    _ratingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _ratingAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ratingAnimationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _feedbackController.dispose();
    _emailController.dispose();
    _ratingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Send Feedback',
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
              _buildQuickFeedback(),
              const SizedBox(height: 24),
              _buildRatingsSection(),
              const SizedBox(height: 24),
              _buildFeedbackForm(),
              const SizedBox(height: 24),
              _buildPrivacySection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildAlternativeFeedback(),
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
            AppColors.success.withOpacity(0.1),
            AppColors.success.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.feedback,
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
                      'Your Voice Matters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Help us improve Arc Vest',
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
            'We value your feedback! Whether it\'s a suggestion, compliment, or concern, your input helps us create a better experience for everyone.',
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

  Widget _buildQuickFeedback() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'How do you feel about Arc Vest?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickFeedbackOptions.map((option) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _overallRating = option['rating'];
                    });
                    _ratingAnimationController.forward().then((_) {
                      _ratingAnimationController.reverse();
                    });
                    HapticFeedback.lightImpact();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _overallRating == option['rating']
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _overallRating == option['rating']
                            ? AppColors.primary
                            : AppColors.divider.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option['emoji'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          option['text'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _overallRating == option['rating']
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: _overallRating == option['rating']
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate Your Experience',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Help us understand what you think about different aspects',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _ratingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _ratingAnimation.value,
                  child: _buildRatingItem(
                    'Overall Experience',
                    _overallRating,
                    (rating) => setState(() => _overallRating = rating),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildRatingItem(
              'Ease of Use',
              _easeOfUseRating,
              (rating) => setState(() => _easeOfUseRating = rating),
            ),
            const SizedBox(height: 16),
            _buildRatingItem(
              'Features & Functionality',
              _featuresRating,
              (rating) => setState(() => _featuresRating = rating),
            ),
            const SizedBox(height: 16),
            _buildRatingItem(
              'Performance & Speed',
              _performanceRating,
              (rating) => setState(() => _performanceRating = rating),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingItem(String title, double rating, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getRatingColor(rating),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                onChanged((index + 1).toDouble());
                HapticFeedback.selectionClick();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: _getRatingColor(rating),
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return AppColors.success;
    if (rating >= 3.0) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildFeedbackForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Feedback Type',
              value: _selectedFeedbackType,
              items: _feedbackTypes,
              onChanged: (value) => setState(() => _selectedFeedbackType = value!),
              icon: Icons.category_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: 'Title (Optional)',
              hint: 'Brief summary of your feedback',
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _feedbackController,
              label: 'Your Feedback',
              hint: 'Tell us what you think! What do you love? What could be improved? Any suggestions?',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please share your feedback';
                }
                if (value.length < 10) {
                  return 'Please provide more details (at least 10 characters)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(
                'Submit anonymously',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'We won\'t be able to follow up with you if you choose this option',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
              value: _isAnonymous,
              onChanged: (value) => setState(() => _isAnonymous = value),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            if (!_isAnonymous) ...[
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email (Optional)',
                hint: 'We\'ll use this to follow up if needed',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
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
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
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
                'Send Feedback',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildAlternativeFeedback() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Other Ways to Share Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlternativeOption(
              Icons.star_outline,
              'Rate us on App Store',
              'Leave a public review',
              () => _showComingSoon('App Store rating'),
            ),
            const Divider(height: 24),
            _buildAlternativeOption(
              Icons.forum_outlined,
              'Join our Community',
              'Connect with other users',
              () => _showComingSoon('Community forum'),
            ),
            const Divider(height: 24),
            _buildAlternativeOption(
              Icons.chat_bubble_outline,
              'Live Chat',
              'Talk to our support team',
              () => Navigator.pushNamed(context, '/live-chat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isSubmitting = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback! We appreciate you taking the time to help us improve.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
        
        // Clear form
        _titleController.clear();
        _feedbackController.clear();
        _emailController.clear();
        setState(() {
          _selectedFeedbackType = 'General Feedback';
          _overallRating = 4.0;
          _easeOfUseRating = 4.0;
          _featuresRating = 4.0;
          _performanceRating = 4.0;
          _isAnonymous = false;
        });
      }
    }
  }
}
