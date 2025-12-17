import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui'; // For ImageFilter
import '../core/constants.dart';
import '../services/supabase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = SupabaseService();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isOtpMode = false;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _emailAuth() async {
    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        // Sign Up
        final res = await _auth.signUpWithEmail(
            _emailCtrl.text.trim(), _passwordCtrl.text);
        if (res?.user != null) {
          // Ideally update user profile with name here
          if (mounted) {
            _showSnack('Account created! Please login.');
            setState(() => _isSignUp = false);
          }
        } else {
          if (mounted) _showSnack('Sign up failed. Try again.');
        }
      } else {
        // Login
        final res = await _auth.signInWithEmail(
            _emailCtrl.text.trim(), _passwordCtrl.text);
        if (res?.user != null) {
          if (mounted) Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);
    try {
      final res = await _auth.signInWithGoogle();
      if (res?.user != null) {
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (mounted) _showSnack('Google sign‑in failed');
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _appleLogin() async {
    setState(() => _isLoading = true);
    try {
      final res = await _auth.signInWithApple();
      if (res?.user != null) {
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (mounted) _showSnack('Apple sign‑in failed');
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      await _auth.sendOtp(_phoneCtrl.text.trim());
      if (mounted) _showSnack('OTP sent – check your messages');
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    try {
      final res =
          await _auth.verifyOtp(_phoneCtrl.text.trim(), _otpCtrl.text.trim());
      if (res?.user != null) {
        if (mounted) Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (mounted) _showSnack('Invalid OTP');
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFFE0B2)
                ], // Soft Orange/Gold
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(duration: 3000.ms, color: Colors.white24),

          // 2. Decorative Circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ).animate().scale(duration: 1000.ms, curve: Curves.easeOutBack),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.1),
              ),
            ).animate().scale(
                duration: 1200.ms, curve: Curves.easeOutBack, delay: 200.ms),
          ),

          // 3. Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Branding
                  const Icon(
                    Icons.storefront_rounded,
                    size: 80,
                    color: AppColors.primary,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.elasticOut)
                      .then()
                      .shimmer(duration: 2000.ms, delay: 1000.ms),

                  const SizedBox(height: 16),

                  Text(
                    'app_name'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  Text(
                    'tagline'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 40),

                  // Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Language Switcher
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.language,
                                    color: AppColors.primary),
                                onPressed: () {
                                  if (context.locale.languageCode == 'en') {
                                    context.setLocale(const Locale('ta'));
                                  } else {
                                    context.setLocale(const Locale('en'));
                                  }
                                },
                              ),
                            ),

                            // Toggle Tabs
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _isSignUp = false;
                                        _isOtpMode = false;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: !_isSignUp && !_isOtpMode
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'login'.tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: !_isSignUp && !_isOtpMode
                                                ? Colors.white
                                                : AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _isSignUp = true;
                                        _isOtpMode = false;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _isSignUp
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'signup'.tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isSignUp
                                                ? Colors.white
                                                : AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form Fields
                            if (!_isOtpMode) ...[
                              if (_isSignUp) ...[
                                TextField(
                                  controller: _nameCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'full_name'.tr(),
                                    prefixIcon:
                                        const Icon(Icons.person_outline),
                                  ),
                                ).animate().fadeIn().slideX(),
                                const SizedBox(height: 16),
                              ],
                              TextField(
                                controller: _emailCtrl,
                                decoration: InputDecoration(
                                  labelText: 'email'.tr(),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                              ).animate().fadeIn(delay: 100.ms).slideX(),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordCtrl,
                                decoration: InputDecoration(
                                  labelText: 'password'.tr(),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                              ).animate().fadeIn(delay: 200.ms).slideX(),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _emailAuth,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    elevation: 4,
                                    shadowColor:
                                        AppColors.primary.withOpacity(0.4),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2))
                                      : Text(
                                          _isSignUp
                                              ? 'create_account'.tr()
                                              : 'login'.tr(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ).animate().fadeIn(delay: 300.ms).scale(),
                              if (!_isSignUp) ...[
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _isOtpMode = true),
                                  child: Text('login_with_otp'.tr()),
                                ),
                              ],
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          Divider(color: Colors.grey.shade300)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text('OR',
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12)),
                                  ),
                                  Expanded(
                                      child:
                                          Divider(color: Colors.grey.shade300)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (!_isSignUp) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _socialButton(
                                      icon: Icons
                                          .g_mobiledata, // Placeholder for Google Logo
                                      label: 'Google',
                                      onTap: _isLoading ? null : _googleLogin,
                                      color: Colors.red.shade500,
                                    ),
                                    _socialButton(
                                      icon: Icons.apple,
                                      label: 'Apple',
                                      onTap: _isLoading ? null : _appleLogin,
                                      color: Colors.black,
                                    ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(delay: 400.ms)
                                    .slideY(begin: 0.2),
                              ],
                            ] else ...[
                              // OTP Mode
                              TextField(
                                controller: _phoneCtrl,
                                decoration: InputDecoration(
                                  labelText: 'phone'.tr(),
                                  prefixIcon: const Icon(Icons.phone_android),
                                ),
                              ).animate().fadeIn().slideX(),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _sendOtp,
                                  child: Text('send_otp'.tr()),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _otpCtrl,
                                decoration: InputDecoration(
                                  labelText: 'enter_otp'.tr(),
                                  prefixIcon: const Icon(Icons.pin),
                                ),
                              ).animate().fadeIn(delay: 100.ms).slideX(),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _verifyOtp,
                                  child: Text('verify_otp'.tr()),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _isOtpMode = false),
                                child: Text('back_to_email'.tr()),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  const SizedBox(height: 30),

                  // Admin Link
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin_seed'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Admin: Seed Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1000.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
      {required IconData icon,
      required String label,
      required VoidCallback? onTap,
      required Color color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
