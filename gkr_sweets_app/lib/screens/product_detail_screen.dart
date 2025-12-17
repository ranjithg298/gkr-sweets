import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/app_dimensions.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _currentImageIndex = 0;

  void _addToCart() {
    context.read<CartProvider>().addItem(widget.product, quantity: _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: PageView.builder(
                  itemCount: widget.product.images.length,
                  onPageChanged: (index) =>
                      setState(() => _currentImageIndex = index),
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.product.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.cardBg,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image indicators
                    if (widget.product.images.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? AppColors.primary
                                  : AppColors.textLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.product.category,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Product name
                    Text(widget.product.name, style: AppTextStyles.heading1),
                    const SizedBox(height: AppDimensions.paddingSmall),

                    // Price and weight
                    Row(
                      children: [
                        Text(widget.product.formattedPrice,
                            style: AppTextStyles.price),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.scale,
                                  size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(widget.product.weight,
                                  style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Description
                    const Text('Description', style: AppTextStyles.heading3),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      widget.product.description,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),

                    // Stock info
                    Row(
                      children: [
                        Icon(
                          widget.product.stock > 10
                              ? Icons.check_circle
                              : Icons.warning,
                          color: widget.product.stock > 10
                              ? AppColors.success
                              : AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.product.stock > 10
                              ? 'In Stock'
                              : 'Low Stock (${widget.product.stock} left)',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: widget.product.stock > 10
                                ? AppColors.success
                                : AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingXLarge),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadiusMedium),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Text('$_quantity', style: AppTextStyles.heading3),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              // Add to cart button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
