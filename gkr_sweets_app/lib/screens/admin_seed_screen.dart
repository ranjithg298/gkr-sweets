import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../core/app_colors.dart';

class AdminSeedScreen extends StatefulWidget {
  const AdminSeedScreen({super.key});

  @override
  State<AdminSeedScreen> createState() => _AdminSeedScreenState();
}

class _AdminSeedScreenState extends State<AdminSeedScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String _status = 'Ready to seed';
  double _progress = 0.0;

  Future<void> _startSeeding() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _status = 'Fetching products.json...';
      _progress = 0.0;
    });

    try {
      // Try to fetch from web server (relative path for Flutter web)
      String content;
      try {
        final response = await http.get(Uri.parse('/products.json'));
        if (response.statusCode == 200) {
          content = response.body;
        } else {
          throw Exception('Failed to load products.json from server');
        }
      } catch (e) {
        // Fallback: try to load from assets
        if (mounted) setState(() => _status = 'Loading from assets...');
        try {
          content = await rootBundle.loadString('assets/products.json');
        } catch (assetError) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _status =
                  'Error: Could not load products.json. Please ensure it is in the web folder or assets folder.';
            });
          }
          return;
        }
      }

      final List<dynamic> products = jsonDecode(content);

      if (mounted) {
        setState(
            () => _status = 'Found ${products.length} products. Seeding...');
      }

      int count = 0;
      int total = products.length;

      for (var p in products) {
        if (p['name'] == '404 Not Found') {
          total--;
          continue;
        }

        try {
          double price = 0.0;
          if (p['price'] is int) {
            price = (p['price'] as int).toDouble();
          } else if (p['price'] is double) {
            price = p['price'];
          }

          List<String> images = [];
          if (p['images'] != null) {
            images = List<String>.from(p['images']);
          }

          await _supabase.from('products').upsert({
            'name': p['name'],
            'description': p['description'] ?? '',
            'price': price,
            'category': p['category'] ?? 'Other',
            'images': images,
            'stock': p['stock'] ?? 100,
            'weight': p['weight'] ?? '1 kg',
            'is_active': p['active'] ?? true,
            'slug': p['slug'] ??
                p['name'].toString().toLowerCase().replaceAll(' ', '-'),
          }, onConflict: 'slug');

          count++;
          if (count % 5 == 0 && mounted) {
            setState(() {
              _progress = count / total;
              _status = 'Seeded $count / $total';
            });
          }
        } catch (e) {
          print('Error seeding ${p['name']}: $e');
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _status = 'Success! Seeded $count products.';
          _progress = 1.0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _status = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Seeding')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              if (_isLoading) LinearProgressIndicator(value: _progress),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _startSeeding,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text('Start Seeding Products',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
