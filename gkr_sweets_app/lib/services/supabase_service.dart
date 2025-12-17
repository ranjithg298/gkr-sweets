import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  User? currentUser;
  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  // ==================== AUTHENTICATION ====================
  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    final res =
        await _client.auth.signInWithPassword(email: email, password: password);
    if (res.user != null) currentUser = res.user;
    return res;
  }

  Future<AuthResponse?> signUpWithEmail(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    if (res.user != null) currentUser = res.user;
    return res;
  }

  Future<AuthResponse?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;

    if (googleAuth.idToken == null || googleAuth.accessToken == null) {
      return null;
    }

    final res = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );

    if (res.user != null) currentUser = res.user;
    return res;
  }

  Future<AuthResponse?> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    if (credential.identityToken == null) return null;

    final res = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: credential.identityToken!,
      accessToken: credential.authorizationCode,
    );

    if (res.user != null) currentUser = res.user;
    return res;
  }

  Future<void> sendOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  Future<AuthResponse?> verifyOtp(String phone, String otp) async {
    final res = await _client.auth
        .verifyOTP(phone: phone, token: otp, type: OtpType.sms);
    if (res.user != null) currentUser = res.user;
    return res;
  }

  // ==================== PRODUCT OPERATIONS ====================

  // Fetch all active products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('active', true)
          .order('name');

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('category', category)
          .eq('active', true)
          .order('name');

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Fetch single product by slug
  Future<Product?> getProductBySlug(String slug) async {
    try {
      final response =
          await _client.from('products').select().eq('slug', slug).single();

      return Product.fromJson(response);
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .ilike('name', '%$query%')
          .eq('active', true)
          .order('name');

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get all unique categories
  Future<List<String>> getCategories() async {
    try {
      final response =
          await _client.from('products').select('category').eq('active', true);

      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return ['Sweets', 'Snacks', 'Groceries', 'Other'];
    }
  }

  // Create order
  Future<Map<String, dynamic>?> createOrder({
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String address,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    try {
      final response = await _client
          .from('orders')
          .insert({
            'customer_name': customerName,
            'customer_email': customerEmail,
            'customer_phone': customerPhone,
            'shipping_address': address,
            'items': items,
            'total_amount': totalAmount,
            'payment_method': paymentMethod,
            'status': 'pending',
          })
          .select()
          .single();

      return response;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      await _client.from('orders').update({'status': status}).eq('id', orderId);
      return true;
    } catch (e) {
      print('Error updating order: $e');
      return false;
    }
  }
}
