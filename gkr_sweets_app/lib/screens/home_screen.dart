import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  String _selectedCategory = 'All';
  List<Product> _products = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Sweets',
    'Snacks',
    'Savories',
    'Ghee Sweets',
    'Milk Sweets'
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      var query = _supabase.from('products').select().eq('is_active', true);
      if (_selectedCategory != 'All') {
        query = query.eq('category', _selectedCategory);
      }

      final data = await query.order('name');
      setState(() {
        _products = (data as List).map((e) => Product.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildPromotions()),
          SliverToBoxAdapter(child: _buildCategories()),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 120,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.secondary.withOpacity(0.05),
              ],
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'app_name'.tr(),
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
            Text(
              'tagline'.tr(),
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            // Navigate to profile
          },
        ),
      ],
    );
  }

  Widget _buildPromotions() {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      child: PageView(
        children: [
          _buildPromoCard(
            'Diwali Special',
            'Get 20% off on all Sweet Boxes',
            Colors.orange.shade100,
            'https://pettikadai.in/cdn/shop/files/Jumbo_Tamil_NAdu_Sweets_1200x1200.jpg',
          ),
          _buildPromoCard(
            'New Arrivals',
            'Try our new Karupatti Sweets',
            Colors.brown.shade100,
            'https://pettikadai.in/cdn/shop/files/Karupatti_5_1200x1200.png',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX();
  }

  Widget _buildPromoCard(
      String title, String subtitle, Color color, String imgUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('buy_now'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return GestureDetector(
            onTap: () => _onCategorySelected(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textLight.withOpacity(0.3),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_products.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('out_of_stock'.tr())),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = _products[index];
            return _buildProductCard(product, index);
          },
          childCount: _products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product_detail',
        arguments: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(product.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedPrice,
                    style: AppTextStyles.price.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add to cart logic
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: AppColors.secondary,
                      ),
                      child: Text('add_to_cart'.tr(),
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1);
  }
}
