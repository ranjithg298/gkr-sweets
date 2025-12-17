class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final bool active;
  final String weight;
  final int stock;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    this.active = true,
    this.weight = '1 kg',
    this.stock = 100,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? 'Other',
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List)
          : [],
      active: json['active'] as bool? ?? true,
      weight: json['weight'] as String? ?? '1 kg',
      stock: json['stock'] as int? ?? 100,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'active': active,
      'weight': weight,
      'stock': stock,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get primaryImage => images.isNotEmpty ? images[0] : '';
  
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
}

class Category {
  final String name;
  final String slug;
  final int productCount;
  final String? imageUrl;

  Category({
    required this.name,
    required this.slug,
    this.productCount = 0,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      slug: json['slug'] as String,
      productCount: json['product_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }
}
