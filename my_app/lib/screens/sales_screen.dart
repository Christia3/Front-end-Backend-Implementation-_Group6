import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class SalesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),

      appBar: AppBar(
        title: Text("Sales"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Today ▼"),
                Text("This Week"),
                Text("This Month"),
              ],
            ),

            SizedBox(height: 20),

            // Stats
            Row(
              children: [
                statBox("Total Sales", "145,000 RWF", Colors.green),
                statBox("Transactions", "8", Colors.white),
                statBox("Avg. Sale", "18,125 RWF", Colors.orange),
              ],
            ),

            SizedBox(height: 20),

            sectionTitle("Recent Transactions"),

            SizedBox(height: 10),

            transaction(
              "5 Feb 2024, 14:30",
              "John Doe",
              ["Maize Flour: 8,000 RWF", "Sunflower Oil: 24,000 RWF"],
              "32,000 RWF",
              "Cash",
            ),

            SizedBox(height: 10),

            transaction(
              "4 Feb 2024, 10:15",
              "Alice Uwimana",
              ["Smartphone: 250,000 RWF"],
              "250,000 RWF",
              "Mobile",
            ),

            Spacer(),

            // Bottom actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("🔍 Search"), Text("Filter ▼"), Text("Export")],
            ),
          ],
        ),
      ),
    );
  }

  Widget statBox(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF0B2545),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(color: valueColor)),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(thickness: 2),
      ],
    );
  }

  Widget transaction(
    String date,
    String name,
    List<String> items,
    String total,
    String method,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        ...items.map(
          (e) => Text("• $e", style: TextStyle(color: Colors.green)),
        ),
        Text("Total: $total | $method"),
      ],
    );
  }
}
