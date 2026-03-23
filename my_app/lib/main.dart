import 'package:flutter/material.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/language_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/google_signin_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/dashboard_screen.dart';

// Product Screens
import 'screens/add_product_screen.dart';
import 'screens/my_products_screen.dart';
import 'screens/edit_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MobiLedger',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF1E6F3D),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        '/language': (context) => LanguageScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/google': (context) => GoogleSignInScreen(),
        '/loading': (context) => LoadingScreen(),
        '/dashboard': (context) => DashboardScreen(),

        // Products
        '/add': (context) => AddProductScreen(),
        '/products': (context) => MyProductsScreen(),
        '/edit': (context) => EditProductScreen(),
      },
    );
  }
}