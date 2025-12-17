import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isAuthenticated) {
            return _buildGuestView(context);
          }
          return _buildAuthenticatedView(context, auth);
        },
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 100,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              'login_to_continue'.tr(),
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'login_benefits'.tr(),
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingSmall,
                ),
                child: Text('login'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context, AuthProvider auth) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      children: [
        // User Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    auth.customer?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  auth.customer?.name ?? 'User',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  auth.customer?.email ?? '',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),

        // Menu Items
        _buildMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'my_orders'.tr(),
          onTap: () {
            // Navigate to orders
          },
        ),
        _buildMenuItem(
          icon: Icons.location_on_outlined,
          title: 'saved_addresses'.tr(),
          onTap: () {
            // Navigate to addresses
          },
        ),
        _buildMenuItem(
          icon: Icons.favorite_outline,
          title: 'wishlist'.tr(),
          onTap: () {
            // Navigate to wishlist
          },
        ),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: 'settings'.tr(),
          onTap: () {
            // Navigate to settings
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'help_support'.tr(),
          onTap: () {
            // Navigate to help
          },
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'logout'.tr(),
          onTap: () async {
            await context.read<AuthProvider>().signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('logged_out'.tr())),
              );
            }
          },
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
