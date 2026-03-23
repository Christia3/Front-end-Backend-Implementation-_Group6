import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircularProgressIndicator(
              color: Color(0xFF1E6F3D),
            ),

            SizedBox(height: 20),

            Text(
              "Loading...\nPlease wait",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E6F3D),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}