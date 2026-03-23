import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class EditProductScreen extends StatelessWidget {

  Widget field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF1E6F3D),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),

      appBar: AppBar(title: Text("Edit Product")),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            SizedBox(height: 10),
            Text("Change Image"),

            SizedBox(height: 20),

            field("Product Name", "Fresh Organic Tomatoes"),
            field("Price", "2,500 RWF"),
            field("Category", "Vegetables"),
            field("Description", "Fresh organic tomatoes"),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("-"),
                SizedBox(width: 20),
                Text("50"),
                SizedBox(width: 20),
                Text("+"),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/products');
              },
              child: Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}