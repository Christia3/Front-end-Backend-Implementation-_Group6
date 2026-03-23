import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {

  // 🔹 STAT CARD
  Widget statCard(IconData icon, String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF0B2545),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF1E6F3D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "View All",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 QUICK BUTTON
  Widget quickButton(BuildContext context, String text, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: Color(0xFF0F4D24),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),

      // 🔻 BOTTOM NAV
      bottomNavigationBar: Container(
        color: Color(0xFF003B1F),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF003B1F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Learn"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔝 HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Color(0xFF003B1F),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "ML",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E6F3D),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  RichText(
                    text: TextSpan(
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

                  Spacer(),

                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  )
                ],
              ),
            ),

            SizedBox(height: 15),

            // 📊 STATS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  statCard(Icons.inventory_2, "Active\nProducts", "12", Colors.green),
                  statCard(Icons.chat_bubble_outline, "Today's\nInquiries", "5", Colors.orange),
                  statCard(Icons.attach_money, "Monthly\nSales", "120,000 RWF", Colors.yellow),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 📋 RECENT ACTIVITY
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.receipt_long, size: 18),
                      SizedBox(width: 5),
                      Text(
                        "Recent Activity",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Divider(thickness: 2),

                  SizedBox(height: 10),

                  Text("• Product A sold - 10,000 RWF"),
                  SizedBox(height: 5),
                  Text("• New inquiry - Product B"),
                  SizedBox(height: 5),
                  Text("• Product C restocked"),

                  SizedBox(height: 12),

                  Container(
                    width: 180,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF5A0F0F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "View All Activity",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // ⚡ QUICK ACTIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.rocket_launch, size: 18),
                      SizedBox(width: 5),
                      Text(
                        "Quick Actions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Divider(thickness: 2),

                  SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      quickButton(context, "Add Product", '/add'),
                      quickButton(context, "View Sales", '/products'),
                      quickButton(context, "Manage Credit", '/products'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}