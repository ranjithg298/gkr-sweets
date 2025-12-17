class Category {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? parentId;
  final String? imageUrl;
  final int sortOrder;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.parentId,
    this.imageUrl,
    this.sortOrder = 0,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      parentId: json['parent_id'] as String?,
      imageUrl: json['image_url'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'parent_id': parentId,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'active': active,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductVariant {
  final String id;
  final String productId;
  final String name;
  final String sku;
  final double price;
  final int stockQuantity;
  final Map<String, dynamic> attributes;
  final bool active;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.stockQuantity,
    this.attributes = const {},
    this.active = true,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'] as int,
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'sku': sku,
      'price': price,
      'stock_quantity': stockQuantity,
      'attributes': attributes,
      'active': active,
    };
  }

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
}

class Customer {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final DateTime? dateOfBirth;
  final int loyaltyPoints;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.loyaltyPoints = 0,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'loyalty_points': loyaltyPoints,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Address {
  final String id;
  final String customerId;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final bool isDefault;

  Address({
    required this.id,
    required this.customerId,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.country = 'India',
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      label: json['label'] as String,
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      country: json['country'] as String? ?? 'India',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'label': label,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'is_default': isDefault,
    };
  }

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null) addressLine2!,
      city,
      state,
      pincode,
    ];
    return parts.join(', ');
  }
}

class Order {
  final String id;
  final String orderNumber;
  final String customerId;
  final String? shippingAddressId;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double shippingAmount;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    this.shippingAddressId,
    required this.subtotal,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.shippingAmount = 0,
    required this.totalAmount,
    this.status = 'pending',
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as String,
      shippingAddressId: json['shipping_address_id'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      shippingAmount: (json['shipping_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'shipping_address_id': shippingAddressId,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'shipping_amount': shippingAmount,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedTotal => '₹${totalAmount.toStringAsFixed(2)}';
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(2)}';
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String? variantId;
  final String productName;
  final String? variantName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.productName,
    this.variantName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      variantId: json['variant_id'] as String?,
      productName: json['product_name'] as String,
      variantName: json['variant_name'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'product_name': productName,
      'variant_name': variantName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}

class Coupon {
  final String id;
  final String code;
  final String? description;
  final String discountType; // 'percentage' or 'fixed'
  final double discountValue;
  final double minOrderValue;
  final double? maxDiscount;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? usageLimit;
  final int usedCount;
  final bool active;

  Coupon({
    required this.id,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue = 0,
    this.maxDiscount,
    this.validFrom,
    this.validTo,
    this.usageLimit,
    this.usedCount = 0,
    this.active = true,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      discountType: json['discount_type'] as String,
      discountValue: (json['discount_value'] as num).toDouble(),
      minOrderValue: (json['min_order_value'] as num?)?.toDouble() ?? 0,
      maxDiscount: (json['max_discount'] as num?)?.toDouble(),
      validFrom: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'] as String)
          : null,
      validTo: json['valid_to'] != null
          ? DateTime.parse(json['valid_to'] as String)
          : null,
      usageLimit: json['usage_limit'] as int?,
      usedCount: json['used_count'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  bool get isValid {
    if (!active) return false;
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validTo != null && now.isAfter(validTo!)) return false;
    if (usageLimit != null && usedCount >= usageLimit!) return false;
    return true;
  }

  double calculateDiscount(double orderAmount) {
    if (!isValid || orderAmount < minOrderValue) return 0;

    double discount = 0;
    if (discountType == 'percentage') {
      discount = orderAmount * (discountValue / 100);
      if (maxDiscount != null && discount > maxDiscount!) {
        discount = maxDiscount!;
      }
    } else {
      discount = discountValue;
    }

    return discount;
  }
}

class Review {
  final String id;
  final String productId;
  final String customerId;
  final String? orderId;
  final int rating;
  final String? reviewText;
  final List<String> images;
  final bool verifiedPurchase;
  final bool approved;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.customerId,
    this.orderId,
    required this.rating,
    this.reviewText,
    this.images = const [],
    this.verifiedPurchase = false,
    this.approved = false,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      customerId: json['customer_id'] as String,
      orderId: json['order_id'] as String?,
      rating: json['rating'] as int,
      reviewText: json['review_text'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : [],
      verifiedPurchase: json['verified_purchase'] as bool? ?? false,
      approved: json['approved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'customer_id': customerId,
      'order_id': orderId,
      'rating': rating,
      'review_text': reviewText,
      'images': images,
      'verified_purchase': verifiedPurchase,
      'approved': approved,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
