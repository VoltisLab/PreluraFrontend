import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildCompanySection(),
            const SizedBox(height: 32),
            _buildAppSection(),
            const SizedBox(height: 32),
            _buildTeamSection(),
            const SizedBox(height: 32),
            _buildContactSection(),
            const SizedBox(height: 32),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.store,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Wholesalers B2B',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 3.0.0',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Made with ❤️ by Voltis Labs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySection() {
    return _buildSection(
      'About Voltis Labs',
      [
        'Voltis Labs is a cutting-edge technology company specializing in innovative mobile and web applications. We are passionate about creating solutions that bridge the gap between businesses and technology.',
        'Founded with a vision to revolutionize the B2B marketplace, our team combines years of experience in software development, user experience design, and business strategy.',
        'We believe in the power of technology to transform traditional business models and create new opportunities for growth and collaboration.',
      ],
      Icons.business,
    );
  }

  Widget _buildAppSection() {
    return _buildSection(
      'About Wholesalers B2B',
      [
        'Wholesalers B2B is a comprehensive marketplace platform designed specifically for wholesale businesses, suppliers, and retailers.',
        'Our platform connects suppliers with retailers, enabling seamless transactions, inventory management, and business growth.',
        'Key features include:',
        '• Advanced product catalog management',
        '• Real-time inventory tracking',
        '• Integrated payment processing',
        '• Analytics and reporting tools',
        '• Multi-vendor support',
        '• Mobile-first design for on-the-go business management',
      ],
      Icons.store,
    );
  }

  Widget _buildTeamSection() {
    return _buildSection(
      'Our Team',
      [
        'Our diverse team of developers, designers, and business strategists work together to deliver exceptional products.',
        'We are committed to continuous innovation and staying at the forefront of technology trends.',
        'Our expertise spans across:',
        '• Flutter & Dart development',
        '• Backend systems and APIs',
        '• UI/UX design',
        '• Business intelligence and analytics',
        '• Cloud infrastructure and security',
      ],
      Icons.people,
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      'Get in Touch',
      [
        'We\'d love to hear from you! Whether you have questions, feedback, or partnership opportunities, we\'re here to help.',
        'Contact Information:',
        '📧 Email: hello@voltislabs.com',
        '🌐 Website: www.voltislabs.com',
        '📱 Phone: +1 (555) 123-4567',
        '📍 Address: 123 Innovation Drive, Tech City, TC 12345',
        '💼 LinkedIn: linkedin.com/company/voltislabs',
        '🐦 Twitter: @VoltisLabs',
      ],
      Icons.contact_mail,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '© 2024 Voltis Labs. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Built with Flutter • Powered by Innovation',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.language, 'Website'),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.email, 'Email'),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.work, 'LinkedIn'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // Handle social media links
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...content.map((text) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        )),
      ],
    );
  }
}
