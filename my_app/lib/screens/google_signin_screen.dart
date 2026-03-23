import 'package:flutter/material.dart';

class GoogleSignInScreen extends StatelessWidget {

  Widget googleButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFF3EAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.g_mobiledata, size: 30),
          SizedBox(width: 8),
          Text("Continue with Google"),
        ],
      ),
    );
  }

  Widget emailButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFD8C2C2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text("SIGN IN WITH EMAIL")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(Icons.g_mobiledata, size: 100, color: Colors.red),

              SizedBox(height: 20),

              Text(
                "Continue with Google",
                style: TextStyle(
                  color: Color(0xFF1E6F3D),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              googleButton(),

              SizedBox(height: 20),

              Text("or use email"),

              SizedBox(height: 20),

              emailButton(),
            ],
          ),
        ),
      ),
    );
  }
}