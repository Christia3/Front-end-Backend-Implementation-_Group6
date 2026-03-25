import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: const Color(0xFF1E6F3D),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E6F3D).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Color(0xFF1E6F3D),
                  ),
                ),
                const SizedBox(height: 24),
                // Success Message
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E6F3D),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Thank you for your purchase',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                // Order Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildOrderDetailRow(
                        'Order Number',
                        '#ORD-2024-001',
                        Icons.receipt,
                      ),
                      const Divider(height: 24),
                      _buildOrderDetailRow(
                        'Order Date',
                        'January 15, 2024',
                        Icons.calendar_today,
                      ),
                      const Divider(height: 24),
                      _buildOrderDetailRow(
                        'Total Amount',
                        '\$145.37',
                        Icons.attach_money,
                      ),
                      const Divider(height: 24),
                      _buildOrderDetailRow(
                        'Payment Method',
                        'Credit Card',
                        Icons.credit_card,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Delivery Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            color: Color(0xFF1E6F3D),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Delivery Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Estimated Delivery:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'January 18 - 20, 2024',
                        style: TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Shipping Address:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Text('John Doe'),
                      const Text('123 Farm Road'),
                      const Text('Green Valley, CA 90210'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6F3D),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/my_orders');
                  },
                  child: const Text('View My Orders'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}
