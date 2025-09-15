import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/vendor_provider.dart';
import '../providers/offer_provider.dart';
import '../providers/auth_provider.dart';
import '../models/offer_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../widgets/offer_container.dart';
import '../widgets/counter_offer_popup.dart';
import 'offer_thread_screen.dart';

enum MessageFilter { all, unread, read, online }

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  MessageFilter _currentFilter = MessageFilter.all;
  final List<Map<String, dynamic>> _messages = [
    // Offer negotiation messages
    {
      'id': 'offer_1',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'https://picsum.photos/40/40?random=100',
      'message': 'Hi! Love this North Face jacket. Would you accept £120?',
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      'isMe': true,
      'isOffer': true,
      'offerPrice': 120.0,
      'originalPrice': 159.0,
    },
    {
      'id': 'offer_2',
      'senderId': 'offer_negotiation',
      'senderName': 'Retro Revival Fashion',
      'senderAvatar': 'https://picsum.photos/40/40?random=offer',
      'message': 'Thanks for the offer! The lowest I can go is £140. It\'s in perfect condition.',
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      'isMe': false,
      'isOfferResponse': true,
    },
    {
      'id': 'offer_3',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'https://picsum.photos/40/40?random=100',
      'message': 'How about £130? I can pick it up today if that works.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      'isMe': true,
      'isOffer': true,
      'offerPrice': 130.0,
      'originalPrice': 159.0,
    },
    {
      'id': 'offer_4',
      'senderId': 'offer_negotiation',
      'senderName': 'Retro Revival Fashion',
      'senderAvatar': 'https://picsum.photos/40/40?random=offer',
      'message': 'I appreciate the quick pickup offer! Let\'s meet in the middle at £135?',
      'timestamp': DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      'isMe': false,
      'isOfferResponse': true,
    },
    {
      'id': 'offer_5',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'https://picsum.photos/40/40?random=100',
      'message': 'Deal! £135 works for me. When can we meet?',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'isMe': true,
      'isOffer': true,
      'offerPrice': 135.0,
      'originalPrice': 159.0,
    },
    {
      'id': 'offer_6',
      'senderId': 'offer_negotiation',
      'senderName': 'Retro Revival Fashion',
      'senderAvatar': 'https://picsum.photos/40/40?random=offer',
      'message': 'Perfect! I\'m free tomorrow after 2pm. I\'ll send you the location details.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isMe': false,
      'isOfferResponse': true,
    },
    // Regular messages
    {
      'id': '1',
      'senderId': 'vendor_1',
      'senderName': 'Urban Streetwear Co.',
      'senderAvatar': 'https://picsum.photos/40/40?random=1',
      'message': 'Hey! Thanks for your interest in our Y2K Leather Bomber Jackets. We have them in stock in all sizes.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isMe': false,
    },
    {
      'id': '2',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'https://picsum.photos/40/40?random=100',
      'message': 'Great! What\'s the wholesale price for a bulk order of 50 pieces?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      'isMe': true,
    },
    {
      'id': '3',
      'senderId': 'vendor_1',
      'senderName': 'Urban Streetwear Co.',
      'senderAvatar': 'https://picsum.photos/40/40?random=1',
      'message': 'For 50 pieces, we can offer £180 per jacket. That includes free shipping and a 30-day return policy.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'isMe': false,
    },
    {
      'id': '4',
      'senderId': 'me',
      'senderName': 'You',
      'senderAvatar': 'https://picsum.photos/40/40?random=100',
      'message': 'That sounds reasonable. Can you send me the size chart and available colors?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
      'isMe': true,
    },
    {
      'id': '5',
      'senderId': 'vendor_1',
      'senderName': 'Urban Streetwear Co.',
      'senderAvatar': 'https://picsum.photos/40/40?random=1',
      'message': 'Absolutely! I\'ll send you the complete catalog with measurements. We have Black, Brown, and Vintage Tan available.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isMe': false,
    },
  ];

  final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'offer_negotiation',
      'name': 'Retro Revival Fashion',
      'avatar': 'https://picsum.photos/50/50?random=offer',
      'lastMessage': 'Perfect! I\'m free tomorrow after 2pm. I\'ll send you the location details.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'unreadCount': 0,
      'isOnline': true,
      'isOfferNegotiation': true,
      'productName': 'The North Face Denali Fleece Jacket',
      'finalPrice': 135.0,
      'originalPrice': 159.0,
    },
    {
      'id': 'vendor_1',
      'name': 'Urban Streetwear Co.',
      'avatar': 'https://picsum.photos/50/50?random=1',
      'lastMessage': 'Absolutely! I\'ll send you the complete catalog...',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'id': 'vendor_2',
      'name': 'Vintage Denim House',
      'avatar': 'https://picsum.photos/50/50?random=2',
      'lastMessage': 'The Levi\'s 501 jeans are back in stock!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'unreadCount': 2,
      'isOnline': false,
    },
    {
      'id': 'vendor_3',
      'name': 'Athletic Gear Pro',
      'avatar': 'https://picsum.photos/50/50?random=3',
      'lastMessage': 'Thanks for the order! Shipping tomorrow.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'id': 'vendor_4',
      'name': 'Luxury Accessories Ltd',
      'avatar': 'https://picsum.photos/50/50?random=4',
      'lastMessage': 'New Burberry collection available',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'unreadCount': 1,
      'isOnline': false,
    },
    {
      'id': 'vendor_5',
      'name': 'Retro Revival Fashion',
      'avatar': 'https://picsum.photos/50/50?random=5',
      'lastMessage': 'Y2K bomber jackets - 40% off this week only!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'unreadCount': 3,
      'isOnline': true,
    },
    {
      'id': 'vendor_6',
      'name': 'Second Chance Vintage',
      'avatar': 'https://picsum.photos/50/50?random=6',
      'lastMessage': 'Your order has been dispatched with tracking #TRK123456',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': 'vendor_7',
      'name': 'Designer Bags Direct',
      'avatar': 'https://picsum.photos/50/50?random=7',
      'lastMessage': 'Limited edition Gucci bags just arrived',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'id': 'vendor_8',
      'name': 'Sneaker Central',
      'avatar': 'https://picsum.photos/50/50?random=8',
      'lastMessage': 'Jordan 1s restock happening tomorrow at 10 AM',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': 'vendor_9',
      'name': 'Fashion Forward',
      'avatar': 'https://picsum.photos/50/50?random=9',
      'lastMessage': 'Can we schedule a call to discuss bulk pricing?',
      'timestamp': DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'id': 'vendor_10',
      'name': 'Trendy Threads Co.',
      'avatar': 'https://picsum.photos/50/50?random=10',
      'lastMessage': 'New summer collection launching next week',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': 'vendor_11',
      'name': 'Elite Footwear',
      'avatar': 'https://picsum.photos/50/50?random=11',
      'lastMessage': 'Nike Air Max 90s - all sizes available',
      'timestamp': DateTime.now().subtract(const Duration(days: 3, hours: 4)),
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'id': 'vendor_12',
      'name': 'Chic Boutique',
      'avatar': 'https://picsum.photos/50/50?random=12',
      'lastMessage': 'Thank you for your recent purchase!',
      'timestamp': DateTime.now().subtract(const Duration(days: 4)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': 'vendor_13',
      'name': 'Urban Outfitters Wholesale',
      'avatar': 'https://picsum.photos/50/50?random=13',
      'lastMessage': 'Bulk discount available for orders over £5,000',
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      'unreadCount': 3,
      'isOnline': true,
    },
    {
      'id': 'vendor_14',
      'name': 'Vintage Finds',
      'avatar': 'https://picsum.photos/50/50?random=14',
      'lastMessage': 'Authentic 90s band tees just in stock',
      'timestamp': DateTime.now().subtract(const Duration(days: 6)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': 'vendor_15',
      'name': 'Luxury Streetwear',
      'avatar': 'https://picsum.photos/50/50?random=15',
      'lastMessage': 'Supreme drop this Friday - be ready!',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
      'unreadCount': 2,
      'isOnline': true,
    },
  ];

  String? _selectedConversationId;

  // Sample transaction data for relationship details
  final List<Map<String, dynamic>> _sampleTransactions = [
    {
      'id': 'txn_001',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'type': 'Order',
      'amount': 1250.00,
      'status': 'Completed',
      'items': ['Y2K Leather Bomber Jacket x2', 'Vintage Denim Jeans x3'],
      'orderId': 'ORD-2024-001',
    },
    {
      'id': 'txn_002',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'type': 'Order',
      'amount': 890.50,
      'status': 'Completed',
      'items': ['Retro Sneakers x4', 'Streetwear Hoodies x2'],
      'orderId': 'ORD-2024-002',
    },
    {
      'id': 'txn_003',
      'date': DateTime.now().subtract(const Duration(days: 78)),
      'type': 'Refund',
      'amount': -150.00,
      'status': 'Processed',
      'items': ['Defective Item Return'],
      'orderId': 'REF-2024-001',
    },
    {
      'id': 'txn_004',
      'date': DateTime.now().subtract(const Duration(days: 120)),
      'type': 'Order',
      'amount': 2100.75,
      'status': 'Completed',
      'items': ['Bulk T-Shirts x50', 'Accessories x20'],
      'orderId': 'ORD-2024-003',
    },
    {
      'id': 'txn_005',
      'date': DateTime.now().subtract(const Duration(days: 180)),
      'type': 'Order',
      'amount': 675.25,
      'status': 'Completed',
      'items': ['Designer Bags x3', 'Luxury Watches x1'],
      'orderId': 'ORD-2024-004',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConversations {
    switch (_currentFilter) {
      case MessageFilter.unread:
        return _conversations.where((c) => c['unreadCount'] > 0).toList();
      case MessageFilter.read:
        return _conversations.where((c) => c['unreadCount'] == 0).toList();
      case MessageFilter.online:
        return _conversations.where((c) => c['isOnline'] == true).toList();
      case MessageFilter.all:
      default:
        return _conversations;
    }
  }

  String _getFilterDisplayName(MessageFilter filter) {
    switch (filter) {
      case MessageFilter.all:
        return 'All';
      case MessageFilter.unread:
        return 'Unread';
      case MessageFilter.read:
        return 'Read';
      case MessageFilter.online:
        return 'Online';
    }
  }

  int _getFilterCount(MessageFilter filter) {
    switch (filter) {
      case MessageFilter.unread:
        return _conversations.where((c) => c['unreadCount'] > 0).length;
      case MessageFilter.read:
        return _conversations.where((c) => c['unreadCount'] == 0).length;
      case MessageFilter.online:
        return _conversations.where((c) => c['isOnline'] == true).length;
      case MessageFilter.all:
      default:
        return _conversations.length;
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderId': 'me',
        'senderName': 'You',
        'senderAvatar': 'https://picsum.photos/40/40?random=100',
        'message': _messageController.text.trim(),
        'timestamp': DateTime.now(),
        'isMe': true,
      });
    });

    _messageController.clear();
  }

  void _showRelationshipDetails(Map<String, dynamic> conversation) {
    print('_showRelationshipDetails called for: ${conversation['name']}');
    final totalSpent = _sampleTransactions
        .where((txn) => txn['type'] == 'Order')
        .fold(0.0, (sum, txn) => sum + (txn['amount'] as double));
    
    final totalRefunds = _sampleTransactions
        .where((txn) => txn['type'] == 'Refund')
        .fold(0.0, (sum, txn) => sum + (txn['amount'] as double).abs());
    
    final netSpent = totalSpent - totalRefunds;
    final orderCount = _sampleTransactions.where((txn) => txn['type'] == 'Order').length;
    final relationshipDays = DateTime.now().difference(_sampleTransactions.last['date']).inDays;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
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
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(conversation['avatar']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Relationship with ${conversation['name']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Customer since ${_formatDate(_sampleTransactions.last['date'])}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildRelationshipStats(netSpent, orderCount, relationshipDays),
                    const SizedBox(height: 24),
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _sampleTransactions.length,
                        itemBuilder: (context, index) {
                          final txn = _sampleTransactions[index];
                          return _buildTransactionCard(txn);
                        },
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

  Widget _buildRelationshipStats(double netSpent, int orderCount, int relationshipDays) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Total Spent', '£${netSpent.toStringAsFixed(2)}', AppColors.primary),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem('Orders', orderCount.toString(), AppColors.success),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem('Relationship', '${relationshipDays} days', AppColors.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> txn) {
    final isRefund = txn['type'] == 'Refund';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                txn['orderId'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isRefund ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  txn['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isRefund ? AppColors.error : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(txn['date']),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            txn['items'].join(', '),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${isRefund ? '-' : '+'}£${txn['amount'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isRefund ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _selectedConversationId == null
          ? _buildConversationsAppBar()
          : _buildChatAppBar(),
      body: _selectedConversationId == null
          ? Column(
              children: [
                _buildFilterTabs(),
                Expanded(child: _buildConversationsList()),
              ],
            )
          : _buildChatView(),
    );
  }

  PreferredSizeWidget _buildConversationsAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: const Text(
        'Messages',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
          onPressed: () {
            // TODO: Implement search
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onPressed: () {
            // TODO: Implement more options
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildChatAppBar() {
    final conversation = _conversations.firstWhere(
      (c) => c['id'] == _selectedConversationId,
    );

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () {
          setState(() {
            _selectedConversationId = null;
          });
        },
      ),
      title: InkWell(
        onTap: () {
          // Navigate to vendor profile
          _openVendorProfile(conversation);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(conversation['avatar']),
                  ),
                  if (conversation['isOnline'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation['name'],
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    Text(
                      conversation['isOnline'] ? 'Online' : 'Last seen recently',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: AppColors.textPrimary),
          onPressed: () {
            // TODO: Implement video call
          },
        ),
        IconButton(
          icon: const Icon(Icons.call, color: AppColors.textPrimary),
          onPressed: () {
            // TODO: Implement voice call
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onSelected: (value) {
            print('Selected menu item: $value');
            if (value == 'relationship') {
              print('Showing relationship details for: ${conversation['name']}');
              _showRelationshipDetails(conversation);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'relationship',
              child: Row(
                children: [
                  Icon(Icons.handshake, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Relationship'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: MessageFilter.values.map((filter) {
            final isSelected = _currentFilter == filter;
            final count = _getFilterCount(filter);
            
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getFilterDisplayName(filter),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _currentFilter = filter;
                    });
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
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildConversationsList() {
    final filteredConversations = _filteredConversations;
    
    if (filteredConversations.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = filteredConversations[index];
        return InkWell(
          onTap: () {
            setState(() {
              _selectedConversationId = conversation['id'];
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: 12,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(conversation['avatar']),
                    ),
                    if (conversation['isOnline'])
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            _formatTimestamp(conversation['timestamp']),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Show offer negotiation details if it's an offer conversation
                      if (conversation['isOfferNegotiation'] == true) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Deal agreed: £${conversation['finalPrice']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          conversation['productName'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['lastMessage'],
                              style: TextStyle(
                                fontSize: 14,
                                color: conversation['unreadCount'] > 0
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: conversation['unreadCount'] > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation['unreadCount'] > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                conversation['unreadCount'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_currentFilter) {
      case MessageFilter.unread:
        message = 'No unread messages';
        icon = Icons.mark_email_read;
        break;
      case MessageFilter.read:
        message = 'No read messages';
        icon = Icons.drafts;
        break;
      case MessageFilter.online:
        message = 'No vendors online';
        icon = Icons.wifi_off;
        break;
      case MessageFilter.all:
      default:
        message = 'No conversations yet';
        icon = Icons.chat_bubble_outline;
        break;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter == MessageFilter.all
                ? 'Start browsing products to connect with vendors'
                : 'Try switching to a different filter',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    
    // Check if this is an offer message
    if (message['isOffer'] == true) {
      return _buildOfferMessage(message);
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(message['senderAvatar']),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: !isMe ? Border.all(color: AppColors.divider.withOpacity(0.3)) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['message'],
                    style: TextStyle(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(message['timestamp']),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(message['senderAvatar']),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOfferMessage(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    final offerPrice = message['offerPrice'] as double;
    final originalPrice = message['originalPrice'] as double;
    
    // Create a temporary offer model for the container
    final offer = OfferModel(
      id: message['id'],
      productId: 'temp_product',
      buyerId: isMe ? 'current_user' : 'other_user',
      sellerId: isMe ? 'other_user' : 'current_user',
      offeredPrice: offerPrice,
      originalPrice: originalPrice,
      message: message['message'],
      status: OfferStatus.pending,
      createdAt: message['timestamp'],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(message['senderAvatar']),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: OfferContainer(
              offer: offer,
              isFromMe: isMe,
              onAccept: !isMe ? () => _handleAcceptOffer(message['id']) : null,
              onDecline: !isMe ? () => _handleDeclineOffer(message) : null,
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(message['senderAvatar']),
            ),
          ],
        ],
      ),
    );
  }

  void _handleAcceptOffer(String offerId) {
    // Handle accepting an offer
    final offerProvider = Provider.of<OfferProvider>(context, listen: false);
    offerProvider.acceptOffer(offerId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer accepted!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleDeclineOffer(Map<String, dynamic> message) {
    // Show counter offer popup
    showDialog(
      context: context,
      builder: (context) => CounterOfferPopup(
        originalPrice: message['originalPrice'] as double,
        currentOffer: message['offerPrice'] as double,
        onCounterOffer: (newPrice, counterMessage) {
          // Handle counter offer
          final offerProvider = Provider.of<OfferProvider>(context, listen: false);
          offerProvider.declineOfferAndCounter(
            originalOfferId: message['id'],
            counterPrice: newPrice,
            message: counterMessage,
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Counter offer sent!'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Implement file attachment
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _openVendorProfile(Map<String, dynamic> conversation) {
    // Find the vendor from the conversation data
    // For demo purposes, we'll use the first vendor from the provider
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    final vendor = vendorProvider.vendors.first; // In a real app, match by conversation ID
    
    Navigator.pushNamed(
      context,
      '/vendor-shop',
      arguments: vendor,
    );
  }
}
