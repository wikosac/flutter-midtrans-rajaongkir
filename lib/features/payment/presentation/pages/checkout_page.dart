import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../shipping/domain/entities/shipping_service.dart';
import '../../domain/entities/payment_request.dart';
import '../../domain/entities/item_detail.dart';
import '../../domain/entities/transaction_details.dart';
import '../bloc/checkout_bloc.dart';
import '../../../../core/utils/currency_formatter.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthBloc>().state;
        final cartState = context.read<CartBloc>().state;
        final bloc = context.read<CheckoutBloc>();
        if (authState is Authenticated) {
          bloc.add(
            InitializeCheckout(
              name: authState.user.name,
              phone: authState.user.phone ?? '',
              address: authState.user.address,
            ),
          );
          bloc.add(
            LoadShippingServices(
              receiverDestinationId: authState.user.address?.id ?? 0,
              itemValue: cartState.totalPrice * 16848,
            ),
          );
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.snapToken != null && state.orderId != null) {
              _handlePaymentSuccess(context, state.snapToken!, state.orderId!);
            }
          },
          child: BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order created successfully')),
                );
              } else if (state is OrderError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShippingInfo(),
                  const SizedBox(height: 24),
                  _buildShippingServices(),
                  const SizedBox(height: 24),
                  _buildOrderSummary(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          state.shippingName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          state.shippingPhone,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.shippingAddress?.label ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShippingServices() {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            state.isLoadingServices
                ? const Center(child: CircularProgressIndicator())
                : state.shippingServices.isEmpty
                ? const Text('No shipping services available')
                : SizedBox(
                    height: 84,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.shippingServices.length,
                      itemBuilder: (context, index) {
                        final service = state.shippingServices[index];
                        final isSelected = state.selectedService == service;
                        return _buildShippingServiceCard(
                          context,
                          service,
                          isSelected,
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildShippingServiceCard(
    BuildContext context,
    ShippingService service,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () =>
          context.read<CheckoutBloc>().add(SelectShippingService(service)),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.shippingName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                Text(
                  service.etd ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Text(
              formatRupiah(service.shippingCost?.toDouble() ?? 0),
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, checkoutState) {
            double idrTotal = cartState.totalPrice * 16848;
            double shippingCost =
                checkoutState.selectedService?.shippingCost?.toDouble() ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...cartState.items.map(
                  (item) => ListTile(
                    title: Text(item.product.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(formatRupiah(item.totalPrice * 16848)),
                  ),
                ),
                const Divider(),
                if (checkoutState.selectedService != null) ...[
                  ListTile(
                    title: const Text('Shipping Cost'),
                    trailing: Text(
                      formatRupiah(shippingCost),
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
                ListTile(
                  title: const Text(
                    'Total (IDR)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: Text(
                    formatRupiah(idrTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildPaymentButton(
                  context,
                  cartState,
                  checkoutState,
                  idrTotal,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentButton(
    BuildContext context,
    CartState cartState,
    CheckoutState checkoutState,
    double idrTotal,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            checkoutState.selectedService == null ||
                checkoutState.isProcessingPayment
            ? null
            : () =>
                  _processPayment(context, cartState, checkoutState, idrTotal),
        child: checkoutState.isProcessingPayment
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Pay with Midtrans'),
      ),
    );
  }

  void _processPayment(
    BuildContext context,
    CartState cartState,
    CheckoutState checkoutState,
    double idrTotal,
  ) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated ||
        checkoutState.isProcessingPayment == true ||
        checkoutState.snapToken != null) {
      return;
    }

    final orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
    log('Processing payment for order: $orderId');
    final request = PaymentRequest(
      transactionDetails: TransactionDetails(
        orderId: orderId,
        grossAmount: idrTotal.toInt(),
      ),
      itemDetails: cartState.items
          .map(
            (item) => ItemDetail(
              id: item.product.id.toString(),
              name: item.product.title,
              price: (item.product.price * 16848).toInt(),
              quantity: item.quantity,
              category: item.product.category,
            ),
          )
          .toList(),
    );

    context.read<CheckoutBloc>().add(ProcessPayment(request));
  }

  void _handlePaymentSuccess(
    BuildContext context,
    String snapToken,
    String orderId,
  ) {
    final authState = context.read<AuthBloc>().state;
    final cartState = context.read<CartBloc>().state;
    final checkoutState = context.read<CheckoutBloc>().state;
    if (authState is! Authenticated) return;

    final order = Order(
      id: orderId,
      userId: authState.user.id,
      items: cartState.items,
      totalAmount: cartState.totalPrice,
      status: 'pending',
      transactionId: snapToken,
      createdAt: DateTime.now(),
      shippingName: checkoutState.shippingName,
      shippingAddress: authState.user.address,
      shippingPhone: checkoutState.shippingPhone,
    );

    context.read<OrderBloc>().add(CreateOrder(order));
    context.read<CartBloc>().add(ClearCart());
    context.pushReplacement('/payment?snapToken=$snapToken&orderId=$orderId');
  }
}
