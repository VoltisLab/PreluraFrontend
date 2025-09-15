import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class CustomerAnalyticsScreen extends StatefulWidget {
  const CustomerAnalyticsScreen({super.key});

  @override
  State<CustomerAnalyticsScreen> createState() => _CustomerAnalyticsScreenState();
}

class _CustomerAnalyticsScreenState extends State<CustomerAnalyticsScreen> {
  String _selectedPeriod = 'Last 30 Days';
  final List<String> _periods = ['Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'Last Year'];

  // Sample customer data
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'customer_1',
      'name': 'Fashion Forward Retail',
      'avatar': 'https://picsum.photos/60/60?random=101',
      'totalSpent': 15420.50,
      'orderCount': 28,
      'avgOrderValue': 550.02,
      'lastOrder': DateTime.now().subtract(const Duration(days: 3)),
      'relationshipDays': 245,
      'loyaltyTier': 'Gold',
      'topCategory': 'Streetwear',
      'growthRate': 15.3,
      'isActive': true,
    },
    {
      'id': 'customer_2',
      'name': 'Urban Boutique Co.',
      'avatar': 'https://picsum.photos/60/60?random=102',
      'totalSpent': 12890.75,
      'orderCount': 35,
      'avgOrderValue': 367.45,
      'lastOrder': DateTime.now().subtract(const Duration(days: 7)),
      'relationshipDays': 180,
      'loyaltyTier': 'Silver',
      'topCategory': 'Vintage',
      'growthRate': 8.7,
      'isActive': true,
    },
    {
      'id': 'customer_3',
      'name': 'Luxury Fashion House',
      'avatar': 'https://picsum.photos/60/60?random=103',
      'totalSpent': 25680.00,
      'orderCount': 12,
      'avgOrderValue': 2140.00,
      'lastOrder': DateTime.now().subtract(const Duration(days: 1)),
      'relationshipDays': 365,
      'loyaltyTier': 'Platinum',
      'topCategory': 'Luxury',
      'growthRate': 22.1,
      'isActive': true,
    },
    {
      'id': 'customer_4',
      'name': 'Street Style Store',
      'avatar': 'https://picsum.photos/60/60?random=104',
      'totalSpent': 8750.25,
      'orderCount': 45,
      'avgOrderValue': 194.45,
      'lastOrder': DateTime.now().subtract(const Duration(days: 14)),
      'relationshipDays': 120,
      'loyaltyTier': 'Bronze',
      'topCategory': 'Sneakers',
      'growthRate': -2.3,
      'isActive': false,
    },
    {
      'id': 'customer_5',
      'name': 'Vintage Vault',
      'avatar': 'https://picsum.photos/60/60?random=105',
      'totalSpent': 19200.80,
      'orderCount': 22,
      'avgOrderValue': 872.76,
      'lastOrder': DateTime.now().subtract(const Duration(days: 5)),
      'relationshipDays': 300,
      'loyaltyTier': 'Gold',
      'topCategory': 'Vintage',
      'growthRate': 12.5,
      'isActive': true,
    },
    {
      'id': 'customer_6',
      'name': 'Designer Outlet',
      'avatar': 'https://picsum.photos/60/60?random=106',
      'totalSpent': 32150.00,
      'orderCount': 8,
      'avgOrderValue': 4018.75,
      'lastOrder': DateTime.now().subtract(const Duration(days: 2)),
      'relationshipDays': 500,
      'loyaltyTier': 'Diamond',
      'topCategory': 'Designer',
      'growthRate': 18.9,
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Customer Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => _periods.map((period) => PopupMenuItem(
              value: period,
              child: Text(period),
            )).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildTopCustomers(),
            const SizedBox(height: 24),
            _buildCustomerInsights(),
            const SizedBox(height: 24),
            _buildCustomerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Period: ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            _selectedPeriod,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    final totalRevenue = _customers.fold(0.0, (sum, customer) => sum + customer['totalSpent']);
    final totalOrders = _customers.fold(0, (sum, customer) => sum + (customer['orderCount'] as int));
    final avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
    final activeCustomers = _customers.where((c) => c['isActive']).length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Total Revenue',
                '£${totalRevenue.toStringAsFixed(0)}',
                Icons.attach_money,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Total Orders',
                totalOrders.toString(),
                Icons.shopping_bag,
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Avg Order Value',
                '£${avgOrderValue.toStringAsFixed(0)}',
                Icons.trending_up,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Active Customers',
                '$activeCustomers/${_customers.length}',
                Icons.people,
                AppColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCustomers() {
    final sortedCustomers = List<Map<String, dynamic>>.from(_customers);
    sortedCustomers.sort((a, b) => (b['totalSpent'] as double).compareTo(a['totalSpent'] as double));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Customers by Revenue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => _showAllTopCustomers(sortedCustomers),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...sortedCustomers.take(3).map((customer) => _buildTopCustomerCard(customer)).toList(),
      ],
    );
  }

  Widget _buildTopCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(customer['avatar']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '£${customer['totalSpent'].toStringAsFixed(0)} • ${customer['orderCount'] as int} orders',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getLoyaltyTierColor(customer['loyaltyTier']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              customer['loyaltyTier'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getLoyaltyTierColor(customer['loyaltyTier']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showHighestOrderDetails(),
                child: _buildInsightCard(
                  'Highest Single Order',
                  '£${_getHighestSingleOrder()}',
                  Icons.trending_up,
                  AppColors.success,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInsightCard(
                'Longest Relationship',
                '${_getLongestRelationship()} days',
                Icons.favorite,
                AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                'Most Orders',
                '${_getMostOrders()} orders',
                Icons.shopping_cart,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInsightCard(
                'Best Growth Rate',
                '${_getBestGrowthRate()}%',
                Icons.show_chart,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Customers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => _showAllCustomers(),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._customers.take(3).map((customer) => _buildCustomerListItem(customer)).toList(),
      ],
    );
  }

  Widget _buildCustomerListItem(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(customer['avatar']),
              ),
              if (customer['isActive'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getLoyaltyTierColor(customer['loyaltyTier']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        customer['loyaltyTier'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getLoyaltyTierColor(customer['loyaltyTier']),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '£${customer['totalSpent'].toStringAsFixed(0)} • ${customer['orderCount'] as int} orders • ${customer['relationshipDays']} days',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Last order: ${_formatDate(customer['lastOrder'])}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${customer['growthRate'] > 0 ? '+' : ''}${customer['growthRate']}%',
                      style: TextStyle(
                        color: customer['growthRate'] > 0 ? AppColors.success : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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

  Color _getLoyaltyTierColor(String tier) {
    switch (tier) {
      case 'Diamond':
        return Colors.purple;
      case 'Platinum':
        return Colors.blue;
      case 'Gold':
        return Colors.amber;
      case 'Silver':
        return Colors.grey;
      case 'Bronze':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  double _getHighestSingleOrder() {
    return _customers.fold(0.0, (max, customer) => 
      customer['avgOrderValue'] > max ? customer['avgOrderValue'] : max);
  }

  int _getLongestRelationship() {
    return _customers.fold(0, (max, customer) => 
      customer['relationshipDays'] > max ? customer['relationshipDays'] : max);
  }

  int _getMostOrders() {
    return _customers.fold(0, (max, customer) => 
      (customer['orderCount'] as int) > max ? (customer['orderCount'] as int) : max);
  }

  double _getBestGrowthRate() {
    return _customers.fold(0.0, (max, customer) => 
      customer['growthRate'] > max ? customer['growthRate'] : max);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAllTopCustomers(List<Map<String, dynamic>> customers) {
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
                    const Text(
                      'All Top Customers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return _buildTopCustomerCard(customer);
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

  void _showAllCustomers() {
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
                    const Text(
                      'All Customers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _customers.length,
                        itemBuilder: (context, index) {
                          final customer = _customers[index];
                          return _buildCustomerListItem(customer);
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

  void _showHighestOrderDetails() {
    final highestOrder = _customers.reduce((a, b) => 
      a['avgOrderValue'] > b['avgOrderValue'] ? a : b);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Highest Single Order Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${highestOrder['name']}'),
            const SizedBox(height: 8),
            Text('Order Value: £${highestOrder['avgOrderValue'].toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Total Spent: £${highestOrder['totalSpent'].toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Orders: ${highestOrder['orderCount']}'),
            const SizedBox(height: 8),
            Text('Loyalty Tier: ${highestOrder['loyaltyTier']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
