import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),

      appBar: AppBar(
        title: Text("Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image
            Center(
              child: Container(
                height: 120,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text("Product Image", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            SizedBox(height: 15),

            Text("Fresh Organic Tomatoes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                Text(" 4.8 (124 reviews)")
              ],
            ),

            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF1E6F3D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("2,500 FRW", style: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 15),

            sectionTitle("Description"),

            greenBox(
              "Fresh organic tomatoes from local farm.\n"
              "Grown without pesticides.\n"
              "Harvested daily.",
            ),

            sectionTitle("Product Details"),

            greenBox(
              "Category: Vegetables\n"
              "Stock: 50 units available\n"
              "Seller: Green Farm\n"
              "Location: Kigali, Rwanda\n"
              "Added: 15 Mar 2026",
            ),

            sectionTitle("Seller Information"),

            greenBox(
              "Green Farm\n⭐ 4.9 (2.3k ratings)\nKigali, Rwanda\n45 products",
            ),

            SizedBox(height: 15),

            sectionTitle("Quantity Available"),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                qtyButton("-"),
                SizedBox(width: 10),
                Text("1"),
                SizedBox(width: 10),
                qtyButton("+"),
              ],
            ),

            SizedBox(height: 15),

            button("ADD TO CART", Colors.black),
            SizedBox(height: 10),
            button("BUY NOW", Color(0xFF0B2545)),
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

  Widget greenBox(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFF0F4D24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget qtyButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF0F4D24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget button(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}