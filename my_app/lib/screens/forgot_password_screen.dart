import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {

  Widget inputField() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Color(0xFFF3EAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.grey),
          hintText: "Email Address",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFC4451C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC4451C),
          elevation: 0,
        ),
        onPressed: () {},
        child: Text("SEND RESET LINK"),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "Forgot Password?\nEnter your email to reset",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E6F3D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 40),

              inputField(),

              button(),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Remember password? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Back to Login",
                      style: TextStyle(color: Colors.orange),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}