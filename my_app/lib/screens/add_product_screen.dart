import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class AddProductScreen extends StatelessWidget {

  Widget input(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget imageBox() {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),

      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            input("Product Name"),
            input("Category"),
            input("Price (RWF)"),
            input("Stock Quantity"),

            Text("Description (optional)"),
            SizedBox(height: 5),
            Container(height: 60, decoration: BoxDecoration(border: Border.all())),
            SizedBox(height: 15),

            Text("Product Images"),
            SizedBox(height: 10),

            Row(
              children: [
                imageBox(),
                imageBox(),
                imageBox(),
                imageBox(),
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                Text("This is an expense")
              ],
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B2545),
                    ),
                    child: Text("Save Product"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5A0F0F),
                    ),
                    child: Text("Cancel"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}