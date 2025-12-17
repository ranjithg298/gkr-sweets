import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text('Remove all items from cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Clear All'),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: AppColors.textLight.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    'Your cart is empty',
                    style: AppTextStyles.heading2.copyWith(color: AppColors.textLight),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  const Text('Add some delicious items!', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                        child: Row(
                          children: [
                            // Product image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                              child: CachedNetworkImage(
                                imageUrl: item.product.primaryImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.cardBg,
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingSmall),
                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.product.formattedPrice,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Quantity controls
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              onPressed: () => cart.decrementQuantity(item.product.id),
                                            ),
                                            Text('${item.quantity}', style: AppTextStyles.bodyMedium),
                                            IconButton(
                                              icon: const Icon(Icons.add, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                              onPressed: () => cart.incrementQuantity(item.product.id),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        item.formattedTotal,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () => cart.removeItem(item.product.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Cart summary
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: AppTextStyles.bodyLarge),
                          Text(cart.cart.formattedSubtotal, style: AppTextStyles.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery', style: AppTextStyles.bodyLarge),
                          Text(cart.cart.formattedDelivery, style: AppTextStyles.bodyLarge),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: AppTextStyles.heading3),
                          Text(cart.cart.formattedTotal, style: AppTextStyles.price),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                            );
                          },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
