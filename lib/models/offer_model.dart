import 'package:flutter/material.dart';

class OfferModel {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final double offeredPrice;
  final double originalPrice;
  final String message;
  final OfferStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? sellerResponse;

  OfferModel({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.offeredPrice,
    required this.originalPrice,
    required this.message,
    this.status = OfferStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.sellerResponse,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      productId: json['productId'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      offeredPrice: json['offeredPrice'].toDouble(),
      originalPrice: json['originalPrice'].toDouble(),
      message: json['message'],
      status: OfferStatus.values.firstWhere(
        (e) => e.toString() == 'OfferStatus.${json['status']}',
        orElse: () => OfferStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      sellerResponse: json['sellerResponse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'offeredPrice': offeredPrice,
      'originalPrice': originalPrice,
      'message': message,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sellerResponse': sellerResponse,
    };
  }

  OfferModel copyWith({
    String? id,
    String? productId,
    String? buyerId,
    String? sellerId,
    double? offeredPrice,
    double? originalPrice,
    String? message,
    OfferStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sellerResponse,
  }) {
    return OfferModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sellerResponse: sellerResponse ?? this.sellerResponse,
    );
  }
}

enum OfferStatus {
  pending,
  accepted,
  rejected,
  counterOffered,
  expired,
}

class MessageThread {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final List<OfferModel> offers;
  final DateTime lastMessageAt;
  final bool hasUnreadMessages;

  MessageThread({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.offers,
    required this.lastMessageAt,
    this.hasUnreadMessages = false,
  });

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'],
      productId: json['productId'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      offers: (json['offers'] as List)
          .map((offer) => OfferModel.fromJson(offer))
          .toList(),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'hasUnreadMessages': hasUnreadMessages,
    };
  }
}
