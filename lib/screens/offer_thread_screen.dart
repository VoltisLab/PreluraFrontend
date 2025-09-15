import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/offer_model.dart';
import '../models/product_model.dart';
import '../providers/offer_provider.dart';
import '../providers/auth_provider.dart';

class OfferThreadScreen extends StatefulWidget {
  final String threadId;

  const OfferThreadScreen({
    super.key,
    required this.threadId,
  });

  @override
  State<OfferThreadScreen> createState() => _OfferThreadScreenState();
}

class _OfferThreadScreenState extends State<OfferThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark thread as read when opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OfferProvider>().markThreadAsRead(widget.threadId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Offer Conversation',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Consumer<OfferProvider>(
        builder: (context, offerProvider, child) {
          final thread = offerProvider.getMessageThread(widget.threadId);
          
          if (thread == null) {
            return const Center(
              child: Text('Thread not found'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  itemCount: thread.offers.length,
                  itemBuilder: (context, index) {
                    final offer = thread.offers[index];
                    return _buildOfferMessage(offer, index == thread.offers.length - 1);
                  },
                ),
              ),
              _buildMessageInput(thread),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOfferMessage(OfferModel offer, bool isLatest) {
    final authProvider = context.read<AuthProvider>();
    final isFromCurrentUser = offer.buyerId == authProvider.currentUser?.id;
    
    // Get product name for context
    final productName = _getProductName(offer.productId);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offer card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isFromCurrentUser 
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFromCurrentUser 
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.divider,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isFromCurrentUser ? 'Your Offer' : 'Offer Received',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isFromCurrentUser 
                              ? AppColors.primary 
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _buildOfferStatus(offer.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '£${offer.offeredPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'for £${offer.originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                if (offer.message.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    offer.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
                if (offer.sellerResponse != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seller Response:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.sellerResponse!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              _formatTimestamp(offer.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferStatus(OfferStatus status) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case OfferStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = Icons.schedule;
        break;
      case OfferStatus.accepted:
        statusColor = Colors.green;
        statusText = 'Accepted';
        statusIcon = Icons.check_circle;
        break;
      case OfferStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Rejected';
        statusIcon = Icons.cancel;
        break;
      case OfferStatus.counterOffered:
        statusColor = AppColors.primary;
        statusText = 'Counter Offer';
        statusIcon = Icons.swap_horiz;
        break;
      case OfferStatus.expired:
        statusColor = Colors.grey;
        statusText = 'Expired';
        statusIcon = Icons.access_time;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 12,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(MessageThread thread) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Here you would typically send the message to the backend
    // For now, we'll just clear the input
    _messageController.clear();
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent!'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getProductName(String productId) {
    switch (productId) {
      case 'north_face_jacket':
        return 'The North Face Denali Fleece Jacket';
      case 'y2k_bomber':
        return 'Y2K Leather Bomber Jacket';
      case 'vintage_denim':
        return 'Vintage 90s Denim Jacket';
      default:
        return 'Product';
    }
  }
}
