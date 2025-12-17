import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gkr_sweets_app/core/constants.dart';

Future<void> main() async {
  // Initialize Supabase
  final supabase = SupabaseClient(
    AppConstants.supabaseUrl,
    AppConstants.supabaseAnonKey,
  );

  final file = File('products.json');
  if (!await file.exists()) {
    print('products.json not found!');
    return;
  }

  final content = await file.readAsString();
  final List<dynamic> products = jsonDecode(content);

  print('Found ${products.length} products. Starting seed...');

  int count = 0;
  for (var p in products) {
    if (p['name'] == '404 Not Found') continue;

    try {
      // Clean price
      double price = 0.0;
      if (p['price'] is int) {
        price = (p['price'] as int).toDouble();
      } else if (p['price'] is double) {
        price = p['price'];
      }

      // Clean images
      List<String> images = [];
      if (p['images'] != null) {
        images = List<String>.from(p['images']);
      }

      await supabase.from('products').upsert({
        'name': p['name'],
        'description': p['description'] ?? '',
        'price': price,
        'category': p['category'] ?? 'Other',
        'images': images,
        'stock': p['stock'] ?? 100,
        'weight': p['weight'] ?? '1 kg',
        'is_active': p['active'] ?? true,
        // Generate a slug if missing or use existing
        'slug': p['slug'] ??
            p['name'].toString().toLowerCase().replaceAll(' ', '-'),
      }, onConflict: 'slug'); // Assuming slug is unique constraint

      count++;
      if (count % 10 == 0) print('Seeded $count products...');
    } catch (e) {
      print('Error seeding ${p['name']}: $e');
    }
  }

  print('Seeding complete! Added/Updated $count products.');
}
