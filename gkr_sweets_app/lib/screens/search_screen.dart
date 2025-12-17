import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _supabase = Supabase.instance.client;
  List<Product> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final data = await _supabase
          .from('products')
          .select()
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_active', true)
          .order('name');

      setState(() {
        _searchResults =
            (data as List).map((e) => Product.fromJson(e)).toList();
        _isSearching = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching: $e')),
        );
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'search_products'.tr(),
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.textLight),
          ),
          onChanged: (value) {
            // Debounce search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_searchController.text == value) {
                _performSearch(value);
              }
            });
          },
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _hasSearched = false;
                });
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'search_hint'.tr(),
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 100,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'no_results'.tr(),
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: AppDimensions.paddingMedium,
        crossAxisSpacing: AppDimensions.paddingMedium,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product_detail',
              arguments: product,
            );
          },
        );
      },
    );
  }
}
