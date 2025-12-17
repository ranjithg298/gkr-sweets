import 'package:flutter/material.dart';
import '../core/constants.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final int productCount;
  final String? imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.productCount,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(name),
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$productCount items',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sweets':
        return Icons.cake;
      case 'snacks':
        return Icons.fastfood;
      case 'groceries':
        return Icons.shopping_basket;
      default:
        return Icons.category;
    }
  }
}
