import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── CONFIG ───────────────────────────────────────────────────────────────────
// Change this to your backend server's IP/URL when running on a real device.
// Use 10.0.2.2 for Android emulator (maps to host machine's localhost).
// Use your machine's local IP (e.g. 192.168.1.x) for a physical device.
const String BASE_URL = 'http://10.0.2.2:5000/api';

// ─── API SERVICE ──────────────────────────────────────────────────────────────
class ApiService {
  static String _baseUrl = BASE_URL;

  // ── TOKEN MANAGEMENT ────────────────────────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data != null) return jsonDecode(data);
    return null;
  }

  // ── HEADERS ─────────────────────────────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── GENERIC REQUEST HELPER ──────────────────────────────────────────────────
  static Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$_baseUrl$endpoint');

    http.Response response;
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported method: $method');
      }
    } on SocketException {
      return {'success': false, 'message': 'No internet connection. Please check your network.'};
    } on HttpException {
      return {'success': false, 'message': 'Could not reach the server.'};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: $e'};
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {'success': false, 'message': 'Invalid server response.'};
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await _request('POST', '/auth/register', body: {
      'full_name': fullName,
      'email': email,
      'password': password,
      if (phone != null) 'phone': phone,
    });
    if (result['success'] == true) {
      await saveToken(result['token']);
      await saveUser(result['user']);
    }
    return result;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _request('POST', '/auth/login', body: {
      'email': email,
      'password': password,
    });
    if (result['success'] == true) {
      await saveToken(result['token']);
      await saveUser(result['user']);
    }
    return result;
  }

  static Future<void> logout() async {
    await clearToken();
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    return _request('POST', '/auth/forgot-password', body: {'email': email});
  }

  static Future<Map<String, dynamic>> getMe() async {
    return _request('GET', '/auth/me');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USER / PROFILE
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getProfile() async {
    return _request('GET', '/users/profile');
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    String? bio,
  }) async {
    return _request('PUT', '/users/profile', body: {
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (bio != null) 'bio': bio,
    });
  }

  static Future<Map<String, dynamic>> updateSettings({
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? darkMode,
  }) async {
    return _request('PUT', '/users/settings', body: {
      if (language != null) 'language': language,
      if (currency != null) 'currency': currency,
      if (notificationsEnabled != null) 'notifications_enabled': notificationsEnabled,
      if (darkMode != null) 'dark_mode': darkMode,
    });
  }

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _request('PUT', '/users/change-password', body: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHOPS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getShops({
    String? search,
    String? category,
    int page = 1,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null && category != 'All') 'category': category,
    };
    final uri = Uri.parse('$_baseUrl/shops').replace(queryParameters: params);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load shops.'};
    }
  }

  static Future<Map<String, dynamic>> getShopById(String shopId) async {
    return _request('GET', '/shops/$shopId');
  }

  static Future<Map<String, dynamic>> getMyShop() async {
    return _request('GET', '/shops/me/my-shop');
  }

  static Future<Map<String, dynamic>> createShop({
    required String name,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? category,
    String? location,
  }) async {
    return _request('POST', '/shops', body: {
      'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (category != null) 'category': category,
      if (location != null) 'location': location,
    });
  }

  static Future<Map<String, dynamic>> updateShop(String shopId, Map<String, dynamic> data) async {
    return _request('PUT', '/shops/$shopId', body: data);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getProducts({
    String? search,
    String? category,
    String? shopId,
    int page = 1,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null) 'category': category,
      if (shopId != null) 'shop_id': shopId,
    };
    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: params);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load products.'};
    }
  }

  static Future<Map<String, dynamic>> getProductById(String productId) async {
    return _request('GET', '/products/$productId');
  }

  static Future<Map<String, dynamic>> getMyProducts() async {
    return _request('GET', '/products/me/my-products');
  }

  static Future<Map<String, dynamic>> createProduct({
    required String name,
    required double price,
    String? description,
    String? currency,
    String? category,
    int? stockQuantity,
    String? unit,
    bool isExpense = false,
  }) async {
    return _request('POST', '/products', body: {
      'name': name,
      'price': price,
      if (description != null) 'description': description,
      'currency': currency ?? 'RWF',
      if (category != null) 'category': category,
      'stock_quantity': stockQuantity ?? 0,
      if (unit != null) 'unit': unit,
      'is_expense': isExpense,
    });
  }

  static Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> data) async {
    return _request('PUT', '/products/$productId', body: data);
  }

  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    return _request('DELETE', '/products/$productId');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CART
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getCart() async {
    return _request('GET', '/cart');
  }

  static Future<Map<String, dynamic>> addToCart(String productId, {int quantity = 1}) async {
    return _request('POST', '/cart', body: {'product_id': productId, 'quantity': quantity});
  }

  static Future<Map<String, dynamic>> updateCartItem(String cartItemId, int quantity) async {
    return _request('PUT', '/cart/$cartItemId', body: {'quantity': quantity});
  }

  static Future<Map<String, dynamic>> removeFromCart(String cartItemId) async {
    return _request('DELETE', '/cart/$cartItemId');
  }

  static Future<Map<String, dynamic>> clearCart() async {
    return _request('DELETE', '/cart');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDERS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> placeOrder({
    required String shippingName,
    required String shippingAddress,
    String? shippingCity,
    String? shippingZip,
    String paymentMethod = 'Mobile Money',
    List<Map<String, dynamic>>? items,
  }) async {
    return _request('POST', '/orders', body: {
      'shipping_name': shippingName,
      'shipping_address': shippingAddress,
      if (shippingCity != null) 'shipping_city': shippingCity,
      if (shippingZip != null) 'shipping_zip': shippingZip,
      'payment_method': paymentMethod,
      if (items != null) 'items': items,
    });
  }

  static Future<Map<String, dynamic>> getMyOrders({String? status, int page = 1}) async {
    final params = <String, String>{
      'page': page.toString(),
      if (status != null) 'status': status,
    };
    final uri = Uri.parse('$_baseUrl/orders').replace(queryParameters: params);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load orders.'};
    }
  }

  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    return _request('GET', '/orders/$orderId');
  }

  static Future<Map<String, dynamic>> getMySales() async {
    return _request('GET', '/orders/sales');
  }

  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    return _request('PUT', '/orders/$orderId/status', body: {'status': status});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CREDITS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getCreditSummary() async {
    return _request('GET', '/credits');
  }

  static Future<Map<String, dynamic>> getCreditTransactions({String? type}) async {
    final params = <String, String>{if (type != null) 'type': type};
    final uri = Uri.parse('$_baseUrl/credits/transactions').replace(queryParameters: params);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load transactions.'};
    }
  }

  static Future<Map<String, dynamic>> transferCredits({
    required String recipientEmail,
    required int amount,
    String? description,
  }) async {
    return _request('POST', '/credits/transfer', body: {
      'recipient_email': recipientEmail,
      'amount': amount,
      if (description != null) 'description': description,
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COURSES
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getCourses({String? category, String? level}) async {
    final params = <String, String>{
      if (category != null && category != 'All') 'category': category,
      if (level != null) 'level': level,
    };
    final uri = Uri.parse('$_baseUrl/courses').replace(queryParameters: params);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to load courses.'};
    }
  }

  static Future<Map<String, dynamic>> enrollCourse(String courseId) async {
    return _request('POST', '/courses/$courseId/enroll');
  }

  static Future<Map<String, dynamic>> getMyCourses() async {
    return _request('GET', '/courses/me/my-courses');
  }

  static Future<Map<String, dynamic>> updateCourseProgress(String courseId, int progress) async {
    return _request('PUT', '/courses/$courseId/progress', body: {'progress': progress});
  }
}
