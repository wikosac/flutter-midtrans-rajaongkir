import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;
  final String orderId;

  const PaymentPage({
    super.key,
    required this.snapToken,
    required this.orderId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (url.contains('status_code=200') ||
                url.contains('transaction_status=settlement')) {
              _handlePaymentSuccess();
            } else if (url.contains('status_code=201') ||
                url.contains('transaction_status=pending')) {
              _handlePaymentPending();
            } else if (url.contains('status_code=202') ||
                url.contains('transaction_status=cancel')) {
              _handlePaymentCancelled();
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}',
        ),
      );
  }

  void _handlePaymentSuccess() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<OrderBloc>().add(
        UpdateOrderStatus(
          widget.orderId,
          'paid',
          authState.user.id,
          transactionId: widget.snapToken,
        ),
      );
      context.read<CartBloc>().add(ClearCart());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment successful!')));
      context.go('/products');
    }
  }

  void _handlePaymentPending() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Payment pending')));
    context.go('/products');
  }

  void _handlePaymentCancelled() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Payment cancelled')));
    context.go('/products');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
