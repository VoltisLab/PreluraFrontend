import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late AnimationController _animationController;

  final List<String> _categories = [
    'All',
    'Getting Started',
    'Orders & Payments',
    'Shipping & Delivery',
    'Returns & Refunds',
    'Account & Profile',
    'Vendors & Products',
    'Technical Issues',
  ];

  final List<FAQItem> _faqItems = [
    // Getting Started
    FAQItem(
      category: 'Getting Started',
      question: 'How do I create an account on Arc Vest Marketplace?',
      answer: 'Creating an account is simple! Tap the "Sign Up" button on the login screen, enter your email, create a password, and verify your email address. You can also sign up using your Google or Apple account for faster registration.',
      isPopular: true,
    ),
    FAQItem(
      category: 'Getting Started',
      question: 'Is Arc Vest Marketplace free to use?',
      answer: 'Yes! Creating an account and browsing products is completely free. We only charge a small transaction fee when you make a purchase, which helps us maintain the platform and support our vendors.',
    ),
    FAQItem(
      category: 'Getting Started',
      question: 'How do I find products I\'m looking for?',
      answer: 'Use our powerful search feature at the top of the home screen. You can search by product name, category, or vendor. Use filters to narrow down results by price, rating, location, and more. You can also browse by categories or check out our curated collections.',
    ),
    FAQItem(
      category: 'Getting Started',
      question: 'What makes Arc Vest different from other marketplaces?',
      answer: 'Arc Vest specializes in vintage and second-hand items from verified vendors worldwide. We focus on unique, sustainable fashion and collectibles. Our platform emphasizes quality, authenticity, and supporting small businesses globally.',
    ),

    // Orders & Payments
    FAQItem(
      category: 'Orders & Payments',
      question: 'What payment methods do you accept?',
      answer: 'We accept all major credit cards (Visa, MasterCard, American Express), PayPal, Apple Pay, Google Pay, and bank transfers. All payments are processed securely through our encrypted payment system.',
      isPopular: true,
    ),
    FAQItem(
      category: 'Orders & Payments',
      question: 'How do I track my order?',
      answer: 'Once your order ships, you\'ll receive a tracking number via email and push notification. You can also check your order status in the "My Orders" section of your profile. Real-time updates will show your package\'s journey from vendor to your door.',
    ),
    FAQItem(
      category: 'Orders & Payments',
      question: 'Can I cancel or modify my order?',
      answer: 'You can cancel orders within 1 hour of placing them if they haven\'t been processed by the vendor. To modify an order, contact the vendor directly through our messaging system. Cancellation policies may vary by vendor.',
    ),
    FAQItem(
      category: 'Orders & Payments',
      question: 'What if I\'m charged incorrectly?',
      answer: 'If you notice an incorrect charge, contact our support team immediately with your order number. We\'ll investigate and resolve any billing issues within 24-48 hours. Refunds for incorrect charges are processed within 3-5 business days.',
    ),
    FAQItem(
      category: 'Orders & Payments',
      question: 'Do you offer payment plans or financing?',
      answer: 'For orders over \$200, we partner with Klarna and Afterpay to offer flexible payment options. You can split your purchase into 4 interest-free payments or choose longer-term financing options at checkout.',
    ),

    // Shipping & Delivery
    FAQItem(
      category: 'Shipping & Delivery',
      question: 'How long does shipping take?',
      answer: 'Shipping times vary by vendor location and your delivery address. Domestic orders typically arrive in 3-7 business days, while international orders can take 7-21 business days. Express shipping options are available for faster delivery.',
      isPopular: true,
    ),
    FAQItem(
      category: 'Shipping & Delivery',
      question: 'How much does shipping cost?',
      answer: 'Shipping costs are calculated based on item size, weight, and destination. Many vendors offer free shipping on orders over a certain amount. You\'ll see exact shipping costs before completing your purchase.',
    ),
    FAQItem(
      category: 'Shipping & Delivery',
      question: 'Do you ship internationally?',
      answer: 'Yes! We have vendors in over 100 countries and ship worldwide. International shipping costs and delivery times vary by destination. Some items may have shipping restrictions due to local regulations.',
    ),
    FAQItem(
      category: 'Shipping & Delivery',
      question: 'What if my package is lost or damaged?',
      answer: 'All shipments are insured. If your package is lost or arrives damaged, contact us within 48 hours with photos (for damaged items). We\'ll work with the carrier and vendor to resolve the issue and ensure you receive a replacement or full refund.',
    ),

    // Returns & Refunds
    FAQItem(
      category: 'Returns & Refunds',
      question: 'What is your return policy?',
      answer: 'Most items can be returned within 30 days of delivery in their original condition. Vintage and custom items may have different return policies set by individual vendors. Check the item\'s return policy before purchasing.',
      isPopular: true,
    ),
    FAQItem(
      category: 'Returns & Refunds',
      question: 'How do I return an item?',
      answer: 'Go to "My Orders" in your profile, select the item you want to return, and follow the return process. You\'ll receive a prepaid return label (for eligible returns) and instructions on how to package and ship the item back.',
    ),
    FAQItem(
      category: 'Returns & Refunds',
      question: 'When will I receive my refund?',
      answer: 'Refunds are processed within 2-3 business days after we receive and inspect the returned item. The refund will appear in your original payment method within 5-10 business days, depending on your bank or card issuer.',
    ),
    FAQItem(
      category: 'Returns & Refunds',
      question: 'Can I exchange an item instead of returning it?',
      answer: 'Exchanges depend on the vendor\'s policy and item availability. Contact the vendor directly through our messaging system to inquire about exchanges. If an exchange isn\'t possible, you can return the item and place a new order.',
    ),

    // Account & Profile
    FAQItem(
      category: 'Account & Profile',
      question: 'How do I update my profile information?',
      answer: 'Go to your profile settings by tapping your profile picture, then select "Edit Profile." You can update your name, email, phone number, shipping addresses, and payment methods. Changes are saved automatically.',
    ),
    FAQItem(
      category: 'Account & Profile',
      question: 'How do I change my password?',
      answer: 'In your profile settings, select "Security" then "Change Password." Enter your current password and your new password twice. For security, you\'ll be logged out of all devices and need to log back in.',
    ),
    FAQItem(
      category: 'Account & Profile',
      question: 'Can I delete my account?',
      answer: 'Yes, you can delete your account in Settings > Privacy > Delete Account. This action is permanent and will remove all your data, order history, and saved items. You\'ll need to confirm this action via email.',
    ),
    FAQItem(
      category: 'Account & Profile',
      question: 'How do I manage my notifications?',
      answer: 'Go to Settings > Notifications to customize what alerts you receive. You can control push notifications, email updates, SMS alerts, and marketing communications. Turn off any notifications you don\'t want to receive.',
    ),

    // Vendors & Products
    FAQItem(
      category: 'Vendors & Products',
      question: 'How do I become a vendor on Arc Vest?',
      answer: 'Apply to become a vendor through our "Sell on Arc Vest" page. You\'ll need to provide business information, product samples, and pass our quality review. Once approved, you can start listing your vintage and second-hand items.',
      isPopular: true,
    ),
    FAQItem(
      category: 'Vendors & Products',
      question: 'How do I contact a vendor?',
      answer: 'On any product page, tap "Message Vendor" to start a conversation. You can ask questions about the item, request additional photos, or discuss custom orders. All conversations are saved in your Messages section.',
    ),
    FAQItem(
      category: 'Vendors & Products',
      question: 'Are all products authentic?',
      answer: 'We work hard to ensure authenticity. All vendors are verified, and we have strict policies against counterfeit items. If you receive a non-authentic item, contact us immediately for a full refund and investigation.',
    ),
    FAQItem(
      category: 'Vendors & Products',
      question: 'Can I request custom or personalized items?',
      answer: 'Many vendors offer customization services. Look for the "Custom Orders" badge on vendor profiles or message them directly to discuss your needs. Custom items may have different pricing and return policies.',
    ),

    // Technical Issues
    FAQItem(
      category: 'Technical Issues',
      question: 'The app is running slowly or crashing. What should I do?',
      answer: 'First, try closing and reopening the app. If issues persist, restart your device or update to the latest app version. Clear the app cache in your device settings if problems continue. Contact support if issues remain unresolved.',
    ),
    FAQItem(
      category: 'Technical Issues',
      question: 'I can\'t log into my account. What should I do?',
      answer: 'Try resetting your password using the "Forgot Password" link. Ensure you\'re using the correct email address. If you\'re still having trouble, your account may be temporarily locked for security reasons. Contact support for assistance.',
    ),
    FAQItem(
      category: 'Technical Issues',
      question: 'Photos aren\'t loading properly. How can I fix this?',
      answer: 'Check your internet connection first. If you\'re on mobile data, try switching to Wi-Fi. Clear the app cache or restart the app. If images still won\'t load, there may be a temporary server issue - try again in a few minutes.',
    ),
    FAQItem(
      category: 'Technical Issues',
      question: 'I\'m not receiving notifications. How do I fix this?',
      answer: 'Check that notifications are enabled in your device settings for Arc Vest. Also verify notification preferences in the app settings. If you\'re still not receiving notifications, try logging out and back in, or reinstall the app.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<FAQItem> get _filteredFAQs {
    var filtered = _faqItems.where((faq) {
      final matchesCategory = _selectedCategory == 'All' || faq.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Sort popular items first
    filtered.sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildFAQList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How can we help?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Find answers to common questions',
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
          Row(
            children: [
              _buildStatItem('${_faqItems.length}', 'Total Questions'),
              const SizedBox(width: 24),
              _buildStatItem('${_categories.length - 1}', 'Categories'),
              const SizedBox(width: 24),
              _buildStatItem('24/7', 'Support Available'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search questions...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.divider.withOpacity(0.3),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQList() {
    final filteredFAQs = _filteredFAQs;
    
    if (filteredFAQs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFAQs.length,
      itemBuilder: (context, index) {
        return _buildFAQItem(filteredFAQs[index], index);
      },
    );
  }

  Widget _buildFAQItem(FAQItem faq, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            if (faq.isPopular) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                faq.question,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.answer,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _showHelpfulDialog(faq),
                      icon: const Icon(Icons.thumb_up_outlined, size: 16),
                      label: const Text('Helpful'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _contactSupport(faq),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Still need help?'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No questions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Try selecting a different category',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/live-chat'),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpfulDialog(FAQItem faq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you!'),
        content: const Text('We\'re glad this answer was helpful. Your feedback helps us improve our FAQ section.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _contactSupport(FAQItem faq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Still need help?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              title: const Text('Live Chat'),
              subtitle: const Text('Get instant help from our support team'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/live-chat');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
              title: const Text('Email Support'),
              subtitle: const Text('Send us a detailed message'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/email-support');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String category;
  final String question;
  final String answer;
  final bool isPopular;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
    this.isPopular = false,
  });
}
