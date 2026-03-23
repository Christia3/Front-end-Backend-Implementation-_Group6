import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class MyProductsScreen extends StatelessWidget {
  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 40),
            SizedBox(height: 10),
            Text("Delete Product?"),
          ],
        ),
        content: Text("This action cannot be undone."),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget productCard(BuildContext context, String title, String price) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF0B2545),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.white),

          Text("Price: $price", style: TextStyle(color: Colors.white)),
          Text("Stock: 24 units", style: TextStyle(color: Colors.white)),
          Text("Category: Food", style: TextStyle(color: Colors.white)),

          SizedBox(height: 10),

          Row(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/edit'),
                child: Text("Edit"),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => showDeleteDialog(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Delete"),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text("View"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),

      appBar: AppBar(title: Text("My Products")),

      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            productCard(context, "Maize Flour (10kg)", "8,000 RWF"),
            productCard(context, "Smartphone X1", "250,000 RWF"),
          ],
        ),
      ),
    );
  }
}
