import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          const Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpOption(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: () => Navigator.pushNamed(context, '/live-chat'),
          ),
          _buildHelpOption(
            context,
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Send us an email',
            onTap: () => Navigator.pushNamed(context, '/email-support'),
          ),
          _buildHelpOption(
            context,
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: 'Speak with our team',
            onTap: () => _showComingSoon(context, 'Phone Support'),
          ),
          _buildHelpOption(
            context,
            icon: Icons.help_outline_rounded,
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
            onTap: () => Navigator.pushNamed(context, '/faq'),
          ),
          _buildHelpOption(
            context,
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Let us know about issues',
            onTap: () => Navigator.pushNamed(context, '/bug-report'),
          ),
          _buildHelpOption(
            context,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts',
            onTap: () => Navigator.pushNamed(context, '/send-feedback'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textHint,
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
