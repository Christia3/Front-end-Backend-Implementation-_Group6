import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {

  Widget languageButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E6F3D),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E6F3D).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E6F3D),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(0xFF1E6F3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "ML",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [

              SizedBox(height: 80),

              // Logo
              logo(),

              SizedBox(height: 15),

              // App Name
              Text(
                "MobiLedger",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Track. Learn. Grow in Your Language.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),

              SizedBox(height: 30),

              Text(
                "Choose a language / Hitamo ururimi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 40),

              // Buttons
              languageButton("ENGLISH", () {
                Navigator.pushNamed(context, '/login');
              }),

              languageButton("KINYARWANDA", () {
                Navigator.pushNamed(context, '/login');
              }),

            ],
          ),
        ),
      ),
    );
  }
}