import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/product_model.dart';
import '../services/supabase_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String? category;

  const ProductsScreen({super.key, this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    List<Product> products;
    if (_selectedCategory != null) {
      products = await _supabaseService.getProductsByCategory(_selectedCategory!);
    } else {
      products = await _supabaseService.getAllProducts();
    }
    
    setState(() {
      _products = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _addToCart(Product product) {
    context.read<CartProvider>().addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory ?? 'All Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : _filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: AppColors.textLight.withOpacity(0.5),
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Text(
                        'No products found',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Product count
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: Row(
                        children: [
                          Text(
                            '${_filteredProducts.length} Products',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Products Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: AppDimensions.paddingSmall,
                          mainAxisSpacing: AppDimensions.paddingSmall,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _navigateToProductDetail(product),
                            onAddToCart: () => _addToCart(product),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
