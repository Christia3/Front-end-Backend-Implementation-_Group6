import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  Widget languageButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white, // Changed to white background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E6F3D), // Green border
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // White background
          foregroundColor: const Color(0xFF1E6F3D), // Green text
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E6F3D), // Green text
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E6F3D), Color(0xFF0A3B1F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E6F3D).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Logo
                logo(),

                const SizedBox(height: 15),

                // App Name
                const Text(
                  "MobiLedger",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E6F3D),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Track. Learn. Grow in Your Language.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E6F3D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Choose a language / Hitamo ururimi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E6F3D),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons
                languageButton("ENGLISH", () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),

                languageButton("KINYARWANDA", () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),

                const SizedBox(height: 20),

                // Optional: Add French button
                languageButton("FRANÇAIS", () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),

                const Spacer(),

                // Footer text
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Select your preferred language",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
