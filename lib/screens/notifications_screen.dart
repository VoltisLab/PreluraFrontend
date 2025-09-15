import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _orderUpdates = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive notifications on your device'),
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive notifications via email'),
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Order Updates'),
                  subtitle: const Text('Get notified about order status changes'),
                  value: _orderUpdates,
                  onChanged: (value) => setState(() => _orderUpdates = value),
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Promotions & Offers'),
                  subtitle: const Text('Receive promotional notifications'),
                  value: _promotions,
                  onChanged: (value) => setState(() => _promotions = value),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
