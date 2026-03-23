import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // ✅ prevents overlap
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 80),

              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E6F3D),
                ),
              ),

              SizedBox(height: 5),
              Text("Sign in to continue"),

              SizedBox(height: 40),

              CustomTextField(
                hint: "Email Address",
                icon: Icons.email,
              ),

              CustomTextField(
                hint: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),

              SizedBox(height: 10),

              // ✅ LOGIN BUTTON CONNECTED
              CustomButton(
                text: "Login",
                color: Color(0xFF0B2545),
                onPressed: () {
                  Navigator.pushNamed(context, '/loading');

                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  });
                },
              ),

              SizedBox(height: 15),

              // ✅ FORGOT PASSWORD CLICKABLE
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgot');
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.green),
                ),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              // ✅ GOOGLE BUTTON CONNECTED
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/google');
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3EAEA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, size: 28),
                      SizedBox(width: 8),
                      Text("Continue with Google"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}