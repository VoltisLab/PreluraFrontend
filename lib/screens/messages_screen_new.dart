import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/offer_provider.dart';
import '../providers/auth_provider.dart';
import '../models/offer_model.dart';
import 'offer_thread_screen.dart';

class MessagesScreenNew extends StatefulWidget {
  const MessagesScreenNew({super.key});

  @override
  State<MessagesScreenNew> createState() => _MessagesScreenNewState();
}

class _MessagesScreenNewState extends State<MessagesScreenNew> {
  @override
  void initState() {
    super.initState();
    // Load sample data for testing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OfferProvider>().loadSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Messages',
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
          final authProvider = context.read<AuthProvider>();
          final threads = offerProvider.getMessageThreadsForUser(
            authProvider.currentUser?.id ?? 'current_user'
          );

          if (threads.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: threads.length,
            itemBuilder: (context, index) {
              final thread = threads[index];
              return _buildOfferThreadCard(thread);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start making offers on products to begin conversations',
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

  Widget _buildOfferThreadCard(MessageThread thread) {
    final latestOffer = thread.offers.isNotEmpty 
        ? thread.offers.last 
        : null;
    
    if (latestOffer == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/offer-thread',
            arguments: thread.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 50,
                  height: 50,
                  color: AppColors.background,
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Thread info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getProductName(thread.productId),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (thread.hasUnreadMessages)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '£${latestOffer.offeredPrice.toStringAsFixed(2)} offer',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latestOffer.message.isNotEmpty 
                          ? latestOffer.message
                          : 'No message',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Status and time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildOfferStatusChip(latestOffer.status),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(latestOffer.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferStatusChip(OfferStatus status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case OfferStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case OfferStatus.accepted:
        statusColor = Colors.green;
        statusText = 'Accepted';
        break;
      case OfferStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      case OfferStatus.counterOffered:
        statusColor = AppColors.primary;
        statusText = 'Counter';
        break;
      case OfferStatus.expired:
        statusColor = Colors.grey;
        statusText = 'Expired';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
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

  String _getProductName(String productId) {
    switch (productId) {
      case 'north_face_jacket':
        return 'The North Face Denali Fleece Jacket';
      case 'y2k_bomber':
        return 'Y2K Leather Bomber Jacket';
      case 'vintage_denim':
        return 'Vintage 90s Denim Jacket';
      default:
        return 'Product Offer';
    }
  }
}
