import 'package:go_router/go_router.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/navigation/main_navigation_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/payment/presentation/pages/checkout_page.dart';
import 'features/payment/presentation/pages/payment_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/products',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final snapToken = state.uri.queryParameters['snapToken'] ?? '';
        final orderId = state.uri.queryParameters['orderId'] ?? '';
        return PaymentPage(snapToken: snapToken, orderId: orderId);
      },
    ),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersPage()),
  ],
);
