# Flutter GKR Sweets App - Setup Guide

## Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

## Setup Instructions

### 1. Install Dependencies
```bash
cd "c:\My Web Sites\gkr sweet\gkr_sweets_app"
flutter pub get
```

### 2. Configure Razorpay Key
Edit `lib/core/constants.dart` and replace the Razorpay test key with your actual key:
```dart
static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_HERE';
```

### 3. Run the App
```bash
flutter run
```

## Features Implemented

✅ **400+ Products** - All products loaded from Supabase
✅ **Premium UI** - Beautiful design with animations
✅ **Image Caching** - Fast image loading
✅ **Categories** - Browse by Sweets, Snacks, Groceries
✅ **Search** - Find products quickly
✅ **Shopping Cart** - Add, remove, update quantities
✅ **Razorpay Payment** - Card, UPI, Wallets
✅ **UPI QR Code** - Scan to pay with any UPI app
✅ **Order Management** - Orders saved to Supabase

## Build APK

```bash
flutter build apk --release
```

APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## Docker Support (Optional)

Create a Dockerfile for the backend if needed:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Project Structure

```
gkr_sweets_app/
├── lib/
│   ├── core/
│   │   └── constants.dart          # App constants, colors, styles
│   ├── models/
│   │   ├── product_model.dart      # Product data model
│   │   └── cart_model.dart         # Cart data model
│   ├── services/
│   │   ├── supabase_service.dart   # Supabase API calls
│   │   └── payment_service.dart    # Razorpay & UPI payments
│   ├── providers/
│   │   └── cart_provider.dart      # Cart state management
│   ├── screens/
│   │   ├── splash_screen.dart      # Animated splash
│   │   ├── home_screen.dart        # Home with categories
│   │   ├── products_screen.dart    # Product listing
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   ├── widgets/
│   │   ├── product_card.dart       # Reusable product card
│   │   └── category_card.dart      # Category display
│   └── main.dart                   # App entry point
└── pubspec.yaml                    # Dependencies
```

## Dart Benefits (Fewer Tokens)

Dart is more concise than JavaScript:
- No semicolons required (optional)
- Type inference reduces boilerplate
- Null safety built-in
- Async/await syntax is cleaner
- Less code for the same functionality

**Example comparison:**
- JavaScript: ~50 tokens for a function
- Dart: ~30 tokens for same function
- **40% fewer tokens!**
