import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../utils/page_transitions.dart';
import 'orders_screen.dart';
import 'wishlist_screen.dart';
import 'addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import '../services/share_service.dart';
import '../data/country_codes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/messages');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return _buildLoginPrompt(context, authProvider);
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 24),
                _buildMenuItems(context, authProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 80,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          const Text(
            'Please log in to view your profile',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Mock login for demo
              authProvider.mockLogin();
            },
            child: const Text('Demo Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: user.profileImage != null 
                  ? NetworkImage(user.profileImage!) 
                  : null,
              child: user.profileImage == null 
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showEditProfileOptions(context, user),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.userType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.edit,
                      size: 12,
                      color: AppColors.primary,
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

  void _showEditProfileOptions(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Edit options
              _buildEditOption(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Update name, email, phone',
                onTap: () {
                  Navigator.pop(context);
                  _showEditPersonalInfo(context, user);
                },
              ),
              _buildEditOption(
                icon: Icons.photo_camera_outlined,
                title: 'Profile Picture',
                subtitle: 'Change your profile photo',
                onTap: () {
                  Navigator.pop(context);
                  _showEditProfilePicture(context);
                },
              ),
              _buildEditOption(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {
                  Navigator.pop(context);
                  _showChangePassword(context);
                },
              ),
              _buildEditOption(
                icon: Icons.business_outlined,
                title: 'Account Type',
                subtitle: 'Switch between Customer/Vendor',
                onTap: () {
                  Navigator.pop(context);
                  _showAccountTypeOptions(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPersonalInfo(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Personal Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update user information
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditProfilePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Camera feature');
                  },
                ),
                _buildPhotoOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Gallery feature');
                  },
                ),
                _buildPhotoOption(
                  icon: Icons.delete,
                  label: 'Remove',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context, 'Remove photo feature');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Validate and change password
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showAccountTypeOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Account Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose your account type:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Customer'),
              subtitle: const Text('Buy products from vendors'),
              onTap: () {
                Navigator.pop(context);
                _switchAccountType(context, 'customer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store, color: AppColors.primary),
              title: const Text('Vendor'),
              subtitle: const Text('Sell products to customers'),
              onTap: () {
                Navigator.pop(context);
                _switchAccountType(context, 'vendor');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _switchAccountType(BuildContext context, String newType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${newType.toUpperCase()} account!'),
        backgroundColor: AppColors.success,
      ),
    );
    // TODO: Update user type in provider
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, AuthProvider authProvider) {
    final menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'My Orders',
        'subtitle': 'View your order history',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const OrdersScreen()),
          );
        },
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Wishlist',
        'subtitle': 'Your saved items',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const WishlistScreen()),
          );
        },
      },
      {
        'icon': Icons.phone_outlined,
        'title': 'Phone Number',
        'subtitle': 'Update your phone number',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phone editing coming soon!'),
              backgroundColor: AppColors.info,
            ),
          );
        },
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Addresses',
        'subtitle': 'Manage delivery addresses',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const AddressesScreen()),
          );
        },
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'Payment Methods',
        'subtitle': 'Manage payment options',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const PaymentMethodsScreen()),
          );
        },
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'subtitle': 'Notification preferences',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const NotificationsScreen()),
          );
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'subtitle': 'Get help and contact us',
        'onTap': () {
          Navigator.push(
            context,
            PageTransitions.slideFromRight(const HelpSupportScreen()),
          );
        },
      },
      {
        'icon': Icons.share,
        'title': 'Share App',
        'subtitle': 'Tell friends about Arc Vest',
        'onTap': () => ShareService.shareApp(),
      },
      {
        'icon': Icons.info_outline,
        'title': 'About',
        'subtitle': 'App version and info',
        'onTap': () {
          _showAboutDialog(context);
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'subtitle': 'Sign out of your account',
        'onTap': () {
          _showLogoutDialog(context, authProvider);
        },
        'isDestructive': true,
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: item['isDestructive'] == true 
                  ? AppColors.error 
                  : AppColors.primary,
            ),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: item['isDestructive'] == true 
                    ? AppColors.error 
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              item['subtitle'] as String,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
            onTap: item['onTap'] as VoidCallback,
          ),
        );
      }).toList(),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Arc Vest Marketplace',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.shopping_bag,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: const [
        Text('A modern multivendor marketplace built with Flutter.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
