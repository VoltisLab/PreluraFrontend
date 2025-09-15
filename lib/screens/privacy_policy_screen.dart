import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Information We Collect',
              [
                'Personal Information: Name, email address, phone number, and business details when you create an account.',
                'Business Information: Company name, business type, and vendor credentials for marketplace participation.',
                'Usage Data: Information about how you use our platform, including products viewed, orders placed, and interactions with vendors.',
                'Location Data: Your location information to provide location-based services and calculate shipping distances.',
                'Device Information: Device type, operating system, and app version for technical support and optimization.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'How We Use Your Information',
              [
                'To provide and maintain our B2B marketplace services.',
                'To process orders, payments, and facilitate transactions between buyers and sellers.',
                'To communicate with you about your account, orders, and platform updates.',
                'To improve our services, develop new features, and enhance user experience.',
                'To provide customer support and respond to your inquiries.',
                'To ensure platform security and prevent fraud.',
                'To comply with legal obligations and enforce our terms of service.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Information Sharing',
              [
                'We share your information with vendors when you place orders to facilitate transactions.',
                'We may share aggregated, non-personal information for business analytics and market research.',
                'We do not sell your personal information to third parties.',
                'We may share information with service providers who assist in platform operations.',
                'We may disclose information if required by law or to protect our rights and safety.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Data Security',
              [
                'We implement industry-standard security measures to protect your information.',
                'All data transmission is encrypted using SSL/TLS protocols.',
                'Access to personal information is restricted to authorized personnel only.',
                'We regularly review and update our security practices.',
                'While we strive to protect your data, no method of transmission over the internet is 100% secure.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Your Rights',
              [
                'Access: You can request access to your personal information.',
                'Correction: You can update or correct your information through your account settings.',
                'Deletion: You can request deletion of your account and associated data.',
                'Portability: You can request a copy of your data in a portable format.',
                'Opt-out: You can opt out of marketing communications at any time.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Cookies and Tracking',
              [
                'We use cookies and similar technologies to enhance your experience.',
                'Cookies help us remember your preferences and improve platform functionality.',
                'You can control cookie settings through your browser preferences.',
                'Some features may not work properly if cookies are disabled.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Third-Party Services',
              [
                'Our platform may integrate with third-party services for payments, maps, and analytics.',
                'These services have their own privacy policies and data practices.',
                'We recommend reviewing their privacy policies before using integrated services.',
                'We are not responsible for the privacy practices of third-party services.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Data Retention',
              [
                'We retain your information for as long as your account is active.',
                'Transaction data may be retained for legal and accounting purposes.',
                'You can request deletion of your data at any time.',
                'Some information may be retained for security and fraud prevention purposes.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Children\'s Privacy',
              [
                'Our platform is not intended for children under 13 years of age.',
                'We do not knowingly collect personal information from children under 13.',
                'If we become aware of such collection, we will delete the information immediately.',
                'Parents should supervise their children\'s use of the internet.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Changes to This Policy',
              [
                'We may update this privacy policy from time to time.',
                'We will notify you of significant changes through the platform or email.',
                'Continued use of our services after changes constitutes acceptance of the new policy.',
                'We encourage you to review this policy periodically.',
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Contact Us',
              [
                'If you have questions about this privacy policy, please contact us:',
                'Email: privacy@wholesalersb2b.com',
                'Phone: +1 (555) 123-4567',
                'Address: 123 Business Street, Commerce City, CC 12345',
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: const Text(
                'Last updated: December 2024\n\nThis privacy policy is effective as of the date listed above and applies to all users of the Wholesalers B2B platform.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...points.map((point) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 8, right: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
