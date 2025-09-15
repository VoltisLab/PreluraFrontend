import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedCategory = 'General Inquiry';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact methods
                  _buildContactMethods(),
                  const SizedBox(height: 32),
                  
                  // Contact form
                  const Text(
                    'Send us a message',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Your Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                          validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Email is required';
                            if (!value!.contains('@')) return 'Please enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        _buildCategoryDropdown(),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _subjectController,
                          label: 'Subject',
                          hint: 'Enter message subject',
                          icon: Icons.subject,
                          validator: (value) => value?.isEmpty ?? true ? 'Subject is required' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _messageController,
                          label: 'Message',
                          hint: 'Describe your inquiry or issue in detail...',
                          icon: Icons.message_outlined,
                          maxLines: 5,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Message is required';
                            if (value!.length < 10) return 'Please provide more details';
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Floating send button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: _isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? 'Sending...' : 'Send Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethods() {
    final methods = [
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Live Chat',
        'subtitle': 'Get instant help',
        'color': AppColors.textSecondary,
        'route': '/live-chat',
      },
      {
        'icon': Icons.email_outlined,
        'title': 'Email Support',
        'subtitle': 'support@wholesalersb2b.com',
        'color': AppColors.textSecondary,
        'route': '/email-support',
      },
      {
        'icon': Icons.phone_outlined,
        'title': 'Phone Support',
        'subtitle': '+1 (555) 123-4567',
        'color': AppColors.textSecondary,
        'action': 'phone',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get in touch',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose your preferred contact method',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ...methods.map((method) {
          return InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              if (method['route'] != null) {
                Navigator.pushNamed(context, method['route'] as String);
              } else if (method['action'] == 'phone') {
                _showPhoneSupport();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (method['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (method['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: method['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      method['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
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
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = [
      'General Inquiry',
      'Order Support',
      'Payment Issues',
      'Technical Support',
      'Vendor Application',
      'Partnership',
      'Feedback',
      'Other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.category_outlined, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      // Simulate sending message
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        setState(() {
          _selectedCategory = 'General Inquiry';
        });

        // Show success
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Message Sent!'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 48,
                  color: AppColors.success,
                ),
                SizedBox(height: 16),
                Text(
                  'Thank you for contacting us! We\'ll get back to you within 24 hours.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPhoneSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.phone,
              size: 48,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              '+1 (555) 123-4567',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Available Monday to Friday\n9:00 AM - 6:00 PM GMT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Phone call feature coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }
}
