import 'package:flutter/material.dart';

// ========== AUTHENTICATION SCREENS ==========
import 'screens/splash_screen.dart';
import 'screens/language_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/google_signin_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/dashboard_screen.dart';

// ========== PRODUCT SCREENS ==========
import 'screens/add_product_screen.dart';
import 'screens/my_products_screen.dart';
import 'screens/edit_product_screen.dart';

// ========== YOUR SCREENS (with _screen suffix) ==========
import 'screens/browse_shops_screen.dart';
import 'screens/learn_hub_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/credit_tracker_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/shop_details_screen.dart';
import 'screens/shopping_cart_screen.dart';
import 'screens/order_confirmation_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFF57C00),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),

      initialRoute: '/',

      routes: {
        // ========== AUTHENTICATION ROUTES ==========
        '/': (context) => SplashScreen(),
        '/language': (context) => LanguageScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/google': (context) => GoogleSignInScreen(),
        '/loading': (context) => LoadingScreen(),
        '/dashboard': (context) => DashboardScreen(),

        // ========== PRODUCT ROUTES ==========
        '/add': (context) => AddProductScreen(),
        '/products': (context) => MyProductsScreen(),
        '/edit': (context) => EditProductScreen(),

        // ========== YOUR ROUTES ==========
        '/browse': (context) => BrowseShopsScreen(),
        '/learn': (context) => LearnHubScreen(),
        '/profile': (context) => ProfileScreen(),
        '/my_orders': (context) => MyOrdersScreen(),
        '/cart': (context) => ShoppingCartScreen(),
        '/checkout': (context) => CheckoutScreen(),
        '/order_confirmation': (context) => OrderConfirmationScreen(),
        '/credit_tracker': (context) => CreditTrackerScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/shop_details': (context) => ShopDetailsScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

// ========== MAIN NAVIGATION SCREEN (Bottom Navigation) ==========
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BrowseShopsScreen(), // Home/Browse
    MyOrdersScreen(), // Orders
    LearnHubScreen(), // Learn
    ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
