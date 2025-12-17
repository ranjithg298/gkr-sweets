import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/extended_models.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser;
  Customer? _customer;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  Customer? get customer => _customer;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _currentUser = _supabase.auth.currentUser;
    if (_currentUser != null) {
      _loadCustomerProfile();
    }

    _supabase.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      if (_currentUser != null) {
        _loadCustomerProfile();
      } else {
        _customer = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadCustomerProfile() async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .eq('user_id', _currentUser!.id)
          .single();
      _customer = Customer.fromJson(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading customer profile: $e');
    }
  }

  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _currentUser = response.user;
      if (_currentUser != null) {
        await _loadCustomerProfile();
      }
      return response;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResponse?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Create customer profile
        await _supabase.from('customers').insert({
          'user_id': response.user!.id,
          'email': email,
          'name': name,
        });
        await _loadCustomerProfile();
      }

      return response;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _currentUser = null;
    _customer = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    DateTime? dateOfBirth,
  }) async {
    if (_customer == null) return;

    try {
      await _supabase.from('customers').update({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
      }).eq('id', _customer!.id);

      await _loadCustomerProfile();
    } catch (e) {
      debugPrint('Update profile error: $e');
    }
  }
}
