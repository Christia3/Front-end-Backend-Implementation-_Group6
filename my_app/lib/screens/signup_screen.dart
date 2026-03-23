import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  Widget inputField(String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Color(0xFFF3EAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget primaryButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF0B2545),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0B2545),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 60),

              // Title
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E6F3D),
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Join MobiLedger today",
                style: TextStyle(color: Colors.grey[600]),
              ),

              SizedBox(height: 40),

              // Inputs
              inputField("Full Name", Icons.person),
              inputField("Email Address", Icons.email),
              inputField("Password", Icons.lock, isPassword: true),
              inputField(
                "Confirm Password",
                Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: 10),

              // ✅ CONNECTED BUTTON
              primaryButton("Sign Up", () {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Account created successfully!")),
                );

                // Go to loading
                Navigator.pushNamed(context, '/loading');

                // Then go to dashboard
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                });
              }),

              SizedBox(height: 15),

              // Back to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}