import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/admin_seed_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';

import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ta')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'GKR Sweets',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: AppTextStyles.heading3,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
            ),
            color: AppColors.surface,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadiusMedium),
              ),
              textStyle: AppTextStyles.button,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
              borderSide:
                  BorderSide(color: AppColors.textLight.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
              borderSide:
                  BorderSide(color: AppColors.textLight.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusMedium),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/main': (context) => const MainNavigationScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/products': (context) => const ProductsScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/admin_seed': (context) => const AdminSeedScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}
