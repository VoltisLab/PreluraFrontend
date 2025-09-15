import 'package:flutter/foundation.dart';
import '../models/offer_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class OfferProvider with ChangeNotifier {
  final List<OfferModel> _offers = [];
  final List<MessageThread> _messageThreads = [];

  List<OfferModel> get offers => List.unmodifiable(_offers);
  List<MessageThread> get messageThreads => List.unmodifiable(_messageThreads);

  // Get offers for a specific product
  List<OfferModel> getOffersForProduct(String productId) {
    return _offers.where((offer) => offer.productId == productId).toList();
  }

  // Get message threads for current user
  List<MessageThread> getMessageThreadsForUser(String userId) {
    return _messageThreads
        .where((thread) => thread.buyerId == userId || thread.sellerId == userId)
        .toList()
      ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
  }

  // Get specific message thread
  MessageThread? getMessageThread(String threadId) {
    try {
      return _messageThreads.firstWhere((thread) => thread.id == threadId);
    } catch (e) {
      return null;
    }
  }

  // Create a new offer
  Future<OfferModel> createOffer({
    required String productId,
    required String buyerId,
    required String sellerId,
    required double offeredPrice,
    required double originalPrice,
    required String message,
  }) async {
    final offer = OfferModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      buyerId: buyerId,
      sellerId: sellerId,
      offeredPrice: offeredPrice,
      originalPrice: originalPrice,
      message: message,
      createdAt: DateTime.now(),
    );

    _offers.add(offer);

    // Create or update message thread
    await _createOrUpdateMessageThread(offer);

    notifyListeners();
    return offer;
  }

  // Create or update message thread
  Future<void> _createOrUpdateMessageThread(OfferModel offer) async {
    final existingThread = _messageThreads.firstWhere(
      (thread) => 
        thread.productId == offer.productId && 
        thread.buyerId == offer.buyerId && 
        thread.sellerId == offer.sellerId,
      orElse: () => MessageThread(
        id: '',
        productId: '',
        buyerId: '',
        sellerId: '',
        offers: [],
        lastMessageAt: DateTime.now(),
      ),
    );

    if (existingThread.id.isEmpty) {
      // Create new thread
      final newThread = MessageThread(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: offer.productId,
        buyerId: offer.buyerId,
        sellerId: offer.sellerId,
        offers: [offer],
        lastMessageAt: DateTime.now(),
        hasUnreadMessages: true,
      );
      _messageThreads.add(newThread);
    } else {
      // Update existing thread
      final threadIndex = _messageThreads.indexWhere((t) => t.id == existingThread.id);
      if (threadIndex != -1) {
        final updatedOffers = List<OfferModel>.from(existingThread.offers)..add(offer);
        _messageThreads[threadIndex] = MessageThread(
          id: existingThread.id,
          productId: existingThread.productId,
          buyerId: existingThread.buyerId,
          sellerId: existingThread.sellerId,
          offers: updatedOffers,
          lastMessageAt: DateTime.now(),
          hasUnreadMessages: true,
        );
      }
    }
  }

  // Respond to an offer
  Future<void> respondToOffer({
    required String offerId,
    required OfferStatus status,
    String? responseMessage,
  }) async {
    final offerIndex = _offers.indexWhere((offer) => offer.id == offerId);
    if (offerIndex != -1) {
      _offers[offerIndex] = _offers[offerIndex].copyWith(
        status: status,
        sellerResponse: responseMessage,
        updatedAt: DateTime.now(),
      );

      // Update message thread
      await _updateMessageThreadWithResponse(offerId, status, responseMessage);
      notifyListeners();
    }
  }

  // Accept an offer
  Future<void> acceptOffer(String offerId) async {
    await respondToOffer(
      offerId: offerId,
      status: OfferStatus.accepted,
      responseMessage: 'Offer accepted! Let\'s arrange pickup.',
    );
  }

  // Decline an offer and create a counter offer
  Future<void> declineOfferAndCounter({
    required String originalOfferId,
    required double counterPrice,
    required String message,
  }) async {
    // Mark original offer as declined
    final originalOfferIndex = _offers.indexWhere((offer) => offer.id == originalOfferId);
    if (originalOfferIndex != -1) {
      final originalOffer = _offers[originalOfferIndex];
      _offers[originalOfferIndex] = originalOffer.copyWith(
        status: OfferStatus.rejected,
        updatedAt: DateTime.now(),
      );

      // Create counter offer
      final counterOffer = OfferModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: originalOffer.productId,
        buyerId: originalOffer.sellerId, // Seller becomes buyer in counter offer
        sellerId: originalOffer.buyerId, // Buyer becomes seller in counter offer
        offeredPrice: counterPrice,
        originalPrice: originalOffer.originalPrice,
        message: message,
        status: OfferStatus.pending,
        createdAt: DateTime.now(),
      );

      _offers.add(counterOffer);
      
      // Update message thread with counter offer
      await _createOrUpdateMessageThread(counterOffer);
      notifyListeners();
    }
  }

  // Update message thread with seller response
  Future<void> _updateMessageThreadWithResponse(
    String offerId,
    OfferStatus status,
    String? responseMessage,
  ) async {
    for (int i = 0; i < _messageThreads.length; i++) {
      final thread = _messageThreads[i];
      final offerIndex = thread.offers.indexWhere((offer) => offer.id == offerId);
      
      if (offerIndex != -1) {
        final updatedOffers = List<OfferModel>.from(thread.offers);
        updatedOffers[offerIndex] = updatedOffers[offerIndex].copyWith(
          status: status,
          sellerResponse: responseMessage,
          updatedAt: DateTime.now(),
        );

        _messageThreads[i] = MessageThread(
          id: thread.id,
          productId: thread.productId,
          buyerId: thread.buyerId,
          sellerId: thread.sellerId,
          offers: updatedOffers,
          lastMessageAt: DateTime.now(),
          hasUnreadMessages: true,
        );
        break;
      }
    }
  }

  // Mark thread as read
  void markThreadAsRead(String threadId) {
    final threadIndex = _messageThreads.indexWhere((thread) => thread.id == threadId);
    if (threadIndex != -1) {
      _messageThreads[threadIndex] = MessageThread(
        id: _messageThreads[threadIndex].id,
        productId: _messageThreads[threadIndex].productId,
        buyerId: _messageThreads[threadIndex].buyerId,
        sellerId: _messageThreads[threadIndex].sellerId,
        offers: _messageThreads[threadIndex].offers,
        lastMessageAt: _messageThreads[threadIndex].lastMessageAt,
        hasUnreadMessages: false,
      );
      notifyListeners();
    }
  }

  // Load sample data for testing
  void loadSampleData() {
    // This would typically load from a backend service
    // For now, we'll add some sample data with realistic negotiations
    
    // Thread 1: Long negotiation example
    final offers1 = [
      OfferModel(
        id: '1',
        productId: 'north_face_jacket',
        buyerId: 'buyer_1',
        sellerId: 'seller_1',
        offeredPrice: 120.0,
        originalPrice: 159.0,
        message: 'Hi! Love this jacket. Would you accept £120?',
        status: OfferStatus.rejected,
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
        sellerResponse: 'Thanks for the offer! The lowest I can go is £140. It\'s in perfect condition.',
      ),
      OfferModel(
        id: '2',
        productId: 'north_face_jacket',
        buyerId: 'buyer_1',
        sellerId: 'seller_1',
        offeredPrice: 130.0,
        originalPrice: 159.0,
        message: 'How about £130? I can pick it up today if that works.',
        status: OfferStatus.rejected,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
        sellerResponse: 'I appreciate the quick pickup offer! Let\'s meet in the middle at £135?',
      ),
      OfferModel(
        id: '3',
        productId: 'north_face_jacket',
        buyerId: 'buyer_1',
        sellerId: 'seller_1',
        offeredPrice: 135.0,
        originalPrice: 159.0,
        message: 'Deal! £135 works for me. When can we meet?',
        status: OfferStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        sellerResponse: 'Perfect! I\'m free tomorrow after 2pm. I\'ll send you the location details.',
      ),
    ];

    // Thread 2: Another negotiation example
    final offers2 = [
      OfferModel(
        id: '4',
        productId: 'y2k_bomber',
        buyerId: 'buyer_2',
        sellerId: 'seller_2',
        offeredPrice: 45.0,
        originalPrice: 65.0,
        message: 'Hey! Is this still available? Would £45 work?',
        status: OfferStatus.counterOffered,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        sellerResponse: 'Hi! Yes it\'s still available. Could you do £55? It\'s barely worn.',
      ),
      OfferModel(
        id: '5',
        productId: 'y2k_bomber',
        buyerId: 'buyer_2',
        sellerId: 'seller_2',
        offeredPrice: 50.0,
        originalPrice: 65.0,
        message: '£50 is my max budget for this. Let me know if that works!',
        status: OfferStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    // Thread 3: Quick acceptance
    final offers3 = [
      OfferModel(
        id: '6',
        productId: 'vintage_denim',
        buyerId: 'buyer_3',
        sellerId: 'seller_3',
        offeredPrice: 35.0,
        originalPrice: 45.0,
        message: 'Hi! Would you take £35 for this?',
        status: OfferStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        sellerResponse: 'Yes! That works perfectly. I can meet you today if you\'re free.',
      ),
    ];

    // Add all offers
    _offers.addAll(offers1);
    _offers.addAll(offers2);
    _offers.addAll(offers3);

    // Create message threads
    final thread1 = MessageThread(
      id: 'thread_1',
      productId: 'north_face_jacket',
      buyerId: 'buyer_1',
      sellerId: 'seller_1',
      offers: offers1,
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      hasUnreadMessages: false,
    );

    final thread2 = MessageThread(
      id: 'thread_2',
      productId: 'y2k_bomber',
      buyerId: 'buyer_2',
      sellerId: 'seller_2',
      offers: offers2,
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      hasUnreadMessages: true,
    );

    final thread3 = MessageThread(
      id: 'thread_3',
      productId: 'vintage_denim',
      buyerId: 'buyer_3',
      sellerId: 'seller_3',
      offers: offers3,
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
      hasUnreadMessages: true,
    );

    _messageThreads.addAll([thread1, thread2, thread3]);
    notifyListeners();
  }
}
