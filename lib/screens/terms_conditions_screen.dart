import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: '1. Acceptance of Terms',
              content: 'By accessing and using the Wholesalers B2B Marketplace ("the Platform"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            _buildSection(
              title: '2. Description of Service',
              content: 'Wholesalers is a B2B marketplace platform that connects wholesale buyers with suppliers, manufacturers, and distributors. The platform facilitates bulk purchasing, order management, and business-to-business transactions.',
            ),
            _buildSection(
              title: '3. User Accounts',
              content: 'To access certain features of the Platform, you must register for an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate, current, and complete information during registration.',
            ),
            _buildSection(
              title: '4. Account Types',
              content: 'The Platform supports multiple account types:\n\n• Customer Accounts: For businesses purchasing wholesale products\n• Vendor Accounts: For suppliers, manufacturers, and distributors selling products\n• Reseller Accounts: For businesses that purchase and resell products\n\nEach account type has specific features and responsibilities.',
            ),
            _buildSection(
              title: '5. Business Transactions',
              content: 'All transactions on the Platform are between buyers and sellers. Wholesalers acts as an intermediary platform and is not a party to these transactions. Users are responsible for:\n\n• Verifying supplier credentials and product quality\n• Negotiating terms and conditions\n• Managing payment and delivery arrangements\n• Resolving disputes directly with trading partners',
            ),
            _buildSection(
              title: '6. Payment Terms',
              content: 'Payment terms are negotiated between buyers and sellers. The Platform may facilitate payment processing but is not responsible for payment disputes. Users agree to:\n\n• Honor agreed payment terms\n• Provide accurate payment information\n• Resolve payment issues directly with trading partners',
            ),
            _buildSection(
              title: '7. Product Listings and Information',
              content: 'Vendors are responsible for the accuracy of their product listings, including:\n\n• Product descriptions and specifications\n• Pricing and availability\n• Quality standards and certifications\n• Compliance with applicable laws and regulations\n\nBuyers should verify all product information before making purchases.',
            ),
            _buildSection(
              title: '8. Minimum Order Quantities',
              content: 'Many products on the Platform have minimum order quantities (MOQs) as specified by vendors. Buyers must meet these requirements to place orders. MOQs are set by individual vendors and may vary by product and region.',
            ),
            _buildSection(
              title: '9. Shipping and Delivery',
              content: 'Shipping terms, costs, and delivery timelines are determined by individual vendors. Buyers and sellers must agree on:\n\n• Shipping methods and carriers\n• Delivery timelines\n• Insurance and liability\n• Customs and import/export requirements',
            ),
            _buildSection(
              title: '10. Returns and Refunds',
              content: 'Return and refund policies are established by individual vendors. Buyers should review vendor policies before making purchases. The Platform may facilitate return processes but is not responsible for vendor return policies.',
            ),
            _buildSection(
              title: '11. Intellectual Property',
              content: 'Users retain ownership of their intellectual property. By using the Platform, users grant Wholesalers a limited license to display their content for platform functionality. Users must not infringe on others\' intellectual property rights.',
            ),
            _buildSection(
              title: '12. Prohibited Activities',
              content: 'Users may not:\n\n• List counterfeit or illegal products\n• Engage in fraudulent activities\n• Violate applicable laws or regulations\n• Infringe on intellectual property rights\n• Provide false or misleading information\n• Attempt to circumvent platform security',
            ),
            _buildSection(
              title: '13. Data Privacy',
              content: 'We collect and process personal and business data in accordance with our Privacy Policy. This includes:\n\n• Account information and business details\n• Transaction history and communication records\n• Usage analytics and platform interactions\n\nData is used to provide services, improve the platform, and ensure security.',
            ),
            _buildSection(
              title: '14. Platform Fees',
              content: 'Wholesalers may charge fees for certain services, including:\n\n• Transaction processing fees\n• Premium listing features\n• Advanced analytics and reporting\n• Additional support services\n\nFee structures will be clearly communicated to users.',
            ),
            _buildSection(
              title: '15. Dispute Resolution',
              content: 'Users are encouraged to resolve disputes directly. For platform-related issues, users can contact our support team. For business disputes between users, we may provide mediation services but are not obligated to resolve commercial disagreements.',
            ),
            _buildSection(
              title: '16. Limitation of Liability',
              content: 'Wholesalers provides the Platform "as is" and is not liable for:\n\n• Product quality or merchantability\n• Business losses or damages\n• Third-party actions or omissions\n• System downtime or technical issues\n• Indirect or consequential damages',
            ),
            _buildSection(
              title: '17. Termination',
              content: 'Either party may terminate this agreement at any time. Wholesalers reserves the right to suspend or terminate accounts that violate these terms. Upon termination, users must cease using the Platform and may lose access to their data.',
            ),
            _buildSection(
              title: '18. Changes to Terms',
              content: 'We may modify these terms at any time. Users will be notified of significant changes. Continued use of the Platform after changes constitutes acceptance of the new terms.',
            ),
            _buildSection(
              title: '19. Governing Law',
              content: 'These terms are governed by the laws of the jurisdiction where Wholesalers operates. Any legal disputes will be resolved in the appropriate courts of that jurisdiction.',
            ),
            _buildSection(
              title: '20. Contact Information',
              content: 'For questions about these terms, please contact us at:\n\nEmail: legal@wholesalers.com\nPhone: +1 (555) 123-4567\nAddress: Wholesalers Legal Department, 123 Business Ave, Suite 100, City, State 12345',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Updated',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'September 10, 2024',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
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
          const SizedBox(height: 8),
          Text(
            content,
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
}
