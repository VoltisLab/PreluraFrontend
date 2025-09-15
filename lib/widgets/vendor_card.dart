import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/app_colors.dart';
import '../utils/country_emoji.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../services/share_service.dart';

class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final bool isCompact;
  final VoidCallback? onTap;

  const VendorCard({
    super.key,
    required this.vendor,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildCompactCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingSmall),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.store,
                  color: AppColors.primary,
                  size: 20,
                ),
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
                            vendor.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (vendor.isVerified)
                          const Icon(
                            Icons.verified,
                            size: 12,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        side: BorderSide(
          color: AppColors.divider.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              // Store Icon (instead of profile photo)
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Shop Name (More prominent and centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      vendor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (vendor.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description (More visible)
              Text(
                '${vendor.address.city}, ${vendor.address.country}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Rating and Review Count (Enhanced)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                    rating: vendor.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 16.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${vendor.rating.toStringAsFixed(1)} (${vendor.reviewCount})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Business Type/Category (instead of random tags)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vendor.categories.isNotEmpty ? vendor.categories.first : 'General',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
