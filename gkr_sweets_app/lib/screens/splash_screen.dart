import 'package:flutter/material.dart';
import 'dart:async';
import '../core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Check authentication and navigate
    Timer(const Duration(seconds: 2), () {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;

    // Always allow browsing - go to main navigation screen
    // Users can login later if they want to checkout
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GKR Logo
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusXLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/gkr_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  const Text(
                    AppConstants.appTagline,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXLarge),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
