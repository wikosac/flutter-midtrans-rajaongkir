import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/edit_profile_page.dart';
import 'features/auth/presentation/pages/search_address_page.dart';
import 'features/auth/presentation/bloc/auth_form_bloc.dart';
import 'features/auth/presentation/bloc/address_search_bloc.dart';
import 'features/navigation/main_navigation_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/payment/presentation/pages/checkout_page.dart';
import 'features/payment/presentation/pages/payment_page.dart';
import 'features/payment/presentation/bloc/checkout_bloc.dart';
import 'injection_container.dart' as di;
import 'features/orders/presentation/pages/orders_page.dart';
import 'features/products/presentation/pages/product_detail_page.dart';
import 'features/products/presentation/bloc/product_detail_bloc.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<AuthFormBloc>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final productId = int.parse(state.uri.queryParameters['id'] ?? '0');
        return BlocProvider(
          create: (_) => di.sl<ProductDetailBloc>(),
          child: ProductDetailPage(productId: productId),
        );
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/search-address',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<AddressSearchBloc>(),
        child: const SearchAddressPage(),
      ),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<CheckoutBloc>(),
        child: const CheckoutPage(),
      ),
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
