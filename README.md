# Flutter Midtrans E-Commerce App

A complete Flutter e-commerce application with Midtrans payment integration, built using Clean Architecture, BLoC pattern, Firebase, and Go Router.

## Features

### Core Features
- ✅ User Authentication (Email/Password & Google Sign-In)
- ✅ Product Listing with Categories
- ✅ Product Detail Page with Image Gallery
- ✅ Shopping Cart Management
- ✅ User Profile Management
- ✅ Address Search with Raja Ongkir API
- ✅ Shipping Service Selection
- ✅ Checkout with Auto-fill User Profile
- ✅ Midtrans Payment Integration
- ✅ Order History & Status Tracking
- ✅ Clean Architecture Implementation
- ✅ State Management with BLoC
- ✅ Dependency Injection with GetIt
- ✅ Navigation with GoRouter
- ✅ Form Validation
- ✅ Optimized Widget Rebuilding

### Additional Features
- ✅ Google Sign-In
- ✅ Raja Ongkir Shipping Integration
- ✅ Order Status Page
- ✅ Cross-platform (Android & iOS)
- ✅ BLoC Architecture for All Features

## Architecture

This project follows Clean Architecture principles with three main layers:

```
lib/
├── core/                    # Core utilities and base classes
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   └── usecases/           # Base use case
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── products/          # Product listing & detail
│   ├── cart/              # Shopping cart
│   ├── payment/           # Payment & checkout
│   ├── orders/            # Order management
│   └── shipping/          # Shipping services
└── injection_container.dart # Dependency injection
```

Each feature follows:
- **Domain Layer**: Entities, Repositories (interfaces), Use Cases
- **Data Layer**: Models, Data Sources, Repository Implementations
- **Presentation Layer**: BLoC, Pages, Widgets

<<<<<<< HEAD
### BLoC Architecture
- **AuthBloc**: User authentication and profile management
- **AuthFormBloc**: Form validation for login/signup
- **AddressSearchBloc**: Address search with Raja Ongkir
- **ProductBloc**: Product listing and categories
- **ProductDetailBloc**: Individual product details
- **CartBloc**: Shopping cart management
- **CheckoutBloc**: Checkout process and shipping
- **OrderBloc**: Order management and history

## Key Features

### BLoC State Management
- Separate BLoCs for each feature domain
- Optimized widget rebuilding with `buildWhen`
- Form validation handled in dedicated BLoCs
- Independent loading states for different data

### Performance Optimizations
- Categories loaded once without rebuilding product widgets
- Image caching with `cached_network_image`
- Efficient state management with Equatable
- Minimal widget rebuilds using BLoC listeners

### Clean Architecture
- Domain entities with immutable data
- Repository pattern with Either for error handling
- Dependency injection with GetIt
- Separation of concerns across layers

=======
>>>>>>> master
## Prerequisites

- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Firebase Account
- Midtrans Account (Sandbox for testing)
- Android Studio / VS Code
- Git

## Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd flutter_midtrans
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Android:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing one
3. Add Android app with package name: `com.example.flutter_midtrans`
4. Download `google-services.json`
5. Place it in `android/app/`

#### iOS:
1. In Firebase Console, add iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/`

#### Enable Firebase Services:
1. Enable **Authentication** (Email/Password & Google)
2. Enable **Cloud Firestore**
3. Create Firestore collections:
   - `users` (for user profiles)
   - `orders` (for order data)

### 4. Midtrans Setup

1. Sign up at [Midtrans](https://midtrans.com/)
2. Get your **Server Key** from Dashboard → Settings → Access Keys
3. Create `.env` file in project root:

```env
SHIPPING_DELIVERY_API_KEY=your_rajaongkir_api_key
```

**Note**: Use Sandbox credentials for testing.

### 5. Raja Ongkir Setup

1. Sign up at [Raja Ongkir](https://rajaongkir.com/)
2. Get your **API Key** from Dashboard
3. Add API key to `.env` file (see step 4 above)

### 6. Google Sign-In Setup (Optional)

#### Android:
1. Get SHA-1 fingerprint:
```bash
cd android
.\gradlew signingReport
```
2. Add SHA-1 to Firebase Console → Project Settings → Your Android App

#### iOS:
1. Add URL scheme in `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

### 7. Run the App

```bash
flutter run
```

## Configuration Files

### Android Configuration

Update `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Add this
}
```

Update `android/build.gradle.kts`:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // Add this
    }
}
```

### iOS Configuration

Update `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

## Usage

### 1. Authentication
- Launch app → Login/Sign Up screen
- Sign up with email/password or use Google Sign-In
- User profile is automatically created in Firestore

### 2. Browse Products
- View all products from DummyJSON API
- Filter by categories
- View product details with image gallery
- Add products to cart

### 3. Shopping Cart
- View cart items
- Update quantities
- Remove items
- See total price

### 4. Checkout
- Shipping information auto-filled from user profile
- Search and select shipping address via Raja Ongkir
- Select shipping service (required)
- View shipping cost (displayed but not added to total)
- Review order summary
- Proceed to payment

### 5. Payment
- Redirected to Midtrans payment page
- Choose payment method (Sandbox mode)
- Complete payment
- Order status updated automatically

### 6. Order History
- View all orders
- Check order status
- See order details

## Testing Payment

Use Midtrans Sandbox test credentials:

**Credit Card:**
- Card Number: `4811 1111 1111 1114`
- CVV: `123`
- Exp Date: Any future date
- OTP: `112233`

**Other Methods:**
- Check [Midtrans Sandbox Documentation](https://docs.midtrans.com/en/technical-reference/sandbox-test)

## API Endpoints

- **Products API**: https://dummyjson.com/products
- **Midtrans Snap API**: https://app.sandbox.midtrans.com/snap/v1/transactions
- **Raja Ongkir API**: https://api-sandbox.collaborator.komerce.id/

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   └── usecases/
│       └── usecase.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   ├── products/
│   ├── cart/
│   ├── payment/
│   ├── orders/
│   └── shipping/
├── injection_container.dart
├── router.dart
└── main.dart
```

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.4
  go_router: ^13.0.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  google_sign_in: ^6.2.1
  http: ^1.1.2
  dartz: ^0.10.1
  cached_network_image: ^3.3.1
  webview_flutter: ^4.4.4
  flutter_dotenv: ^5.1.0
```

## Troubleshooting

### Firebase Issues
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations
- Check Firebase project configuration
- Verify package name matches Firebase app

### Midtrans Issues
- Verify Server Key is correct
- Use Sandbox mode for testing
- Check network connectivity

### Raja Ongkir Issues
- Verify API Key is correct in `.env` file
- Ensure `.env` file is in project root
- Check API quota limits

### Build Issues
```bash
flutter clean
flutter pub get
flutter run
```

## Future Enhancements

- [ ] Product search functionality
- [ ] Wishlist feature
- [ ] Product reviews and ratings
- [ ] Push notifications for order updates
- [ ] Multiple payment methods
- [ ] Promo codes and discounts
- [ ] Add shipping cost to total amount

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please open an issue in the repository.

## Acknowledgments

- [DummyJSON API](https://dummyjson.com/) for product data
- [Midtrans](https://midtrans.com/) for payment gateway
- [Raja Ongkir](https://rajaongkir.com/) for shipping services
- [Firebase](https://firebase.google.com/) for backend services
- Flutter community for amazing packages
