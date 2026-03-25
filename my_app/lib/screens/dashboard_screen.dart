import 'package:flutter/material.dart';
import '../main.dart'; // Import for MainNavigationScreen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // 🔹 STAT CARD
  Widget statCard(
    IconData icon,
    String title,
    String value,
    Color valueColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0B2545),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E6F3D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 QUICK BUTTON
  Widget quickButton(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF0F4D24),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // 🔹 MENU ITEM
  Widget menuItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E6F3D)),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      // 🔻 BOTTOM NAV - Now navigates to your screens
      bottomNavigationBar: Container(
        color: const Color(0xFF003B1F),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF003B1F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/browse');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/learn');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "Learn",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔝 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF003B1F),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "ML",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E6F3D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Fixed: Removed const from RichText
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Mobi",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          TextSpan(
                            text: "Ledger",
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 📊 STATS - Now clickable
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    statCard(
                      Icons.inventory_2,
                      "Active\nProducts",
                      "12",
                      Colors.green,
                      () => Navigator.pushNamed(context, '/products'),
                    ),
                    statCard(
                      Icons.chat_bubble_outline,
                      "Today's\nInquiries",
                      "5",
                      Colors.orange,
                      () => Navigator.pushNamed(context, '/my_orders'),
                    ),
                    statCard(
                      Icons.attach_money,
                      "Monthly\nSales",
                      "120,000 RWF",
                      Colors.yellow,
                      () => Navigator.pushNamed(context, '/credit_tracker'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📋 RECENT ACTIVITY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long, size: 18),
                        const SizedBox(width: 5),
                        const Text(
                          "Recent Activity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 10),
                    const Text("• Product A sold - 10,000 RWF"),
                    const SizedBox(height: 5),
                    const Text("• New inquiry - Product B"),
                    const SizedBox(height: 5),
                    const Text("• Product C restocked"),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/my_orders'),
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A0F0F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "View All Activity",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⚡ QUICK ACTIONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.rocket_launch, size: 18),
                        const SizedBox(width: 5),
                        const Text(
                          "Quick Actions",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        quickButton(context, "Add Product", '/add'),
                        quickButton(context, "My Products", '/products'),
                        quickButton(
                          context,
                          "Credit Tracker",
                          '/credit_tracker',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        quickButton(context, "Shopping Cart", '/cart'),
                        quickButton(context, "My Orders", '/my_orders'),
                        quickButton(context, "Settings", '/settings'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📱 ADDITIONAL MENU SECTION
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Quick Links",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              menuItem("Browse Shops", Icons.store, () {
                Navigator.pushNamed(context, '/browse');
              }),
              menuItem("Learn Hub", Icons.school, () {
                Navigator.pushNamed(context, '/learn');
              }),
              menuItem("My Orders", Icons.shopping_bag, () {
                Navigator.pushNamed(context, '/my_orders');
              }),
              menuItem("Shopping Cart", Icons.shopping_cart, () {
                Navigator.pushNamed(context, '/cart');
              }),
              menuItem("Edit Profile", Icons.person, () {
                Navigator.pushNamed(context, '/edit_profile');
              }),
              menuItem("Shop Details", Icons.storefront, () {
                Navigator.pushNamed(context, '/shop_details');
              }),
              menuItem("Settings", Icons.settings, () {
                Navigator.pushNamed(context, '/settings');
              }),

              const SizedBox(height: 20),

              // 🔄 ENTER MARKETPLACE BUTTON - Navigate to Main Navigation
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E6F3D), Color(0xFF0A3B1F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainNavigationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Enter Full Marketplace',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
