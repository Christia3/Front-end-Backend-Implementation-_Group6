import 'package:flutter/material.dart';

class CreditTrackerScreen extends StatefulWidget {
  const CreditTrackerScreen({super.key});

  @override
  State<CreditTrackerScreen> createState() => _CreditTrackerScreenState();
}

class _CreditTrackerScreenState extends State<CreditTrackerScreen> {
  int userCredits = 1250;

  final List<Map<String, dynamic>> transactions = [
    {
      'description': 'Product Sale - Organic Vegetables',
      'amount': 250,
      'type': 'credit',
      'date': '2024-01-15',
    },
    {
      'description': 'Fertilizer Purchase',
      'amount': 150,
      'type': 'debit',
      'date': '2024-01-14',
    },
    {
      'description': 'Referral Bonus',
      'amount': 100,
      'type': 'credit',
      'date': '2024-01-12',
    },
    {
      'description': 'Equipment Rental',
      'amount': 75,
      'type': 'debit',
      'date': '2024-01-10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Tracker'),
        backgroundColor: const Color(0xFF1E6F3D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show transaction history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Credit Balance Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E6F3D), Color(0xFF0A3B1F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Credits',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$userCredits',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Earned', '3,450', Icons.trending_up),
                      _buildStatCard('Spent', '2,200', Icons.trending_down),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    'Add Credits',
                    Icons.add_circle,
                    () {},
                    Colors.green,
                  ),
                  _buildActionButton(
                    'Transfer',
                    Icons.swap_horiz,
                    () {},
                    Colors.blue,
                  ),
                  _buildActionButton(
                    'Redeem',
                    Icons.card_giftcard,
                    () {},
                    Colors.orange,
                  ),
                  _buildActionButton(
                    'History',
                    Icons.history,
                    () {},
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text('View All')),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isCredit = transaction['type'] == 'credit';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCredit
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    child: Icon(
                      isCredit ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(transaction['description']),
                  subtitle: Text(transaction['date']),
                  trailing: Text(
                    '${isCredit ? '+' : '-'}\$${transaction['amount']}',
                    style: TextStyle(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
            iconSize: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
