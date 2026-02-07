import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../../injection_container.dart' as di;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _nameController.text = authState.user.name;
      _phoneController.text = authState.user.phone ?? '';
      _addressController.text = authState.user.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocListener<OrderBloc, OrderState>(
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
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  double idrTotal = cartState.totalPrice * 16848.0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...cartState.items.map(
                        (item) => ListTile(
                          title: Text(item.product.title),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text(
                          'Total (USD)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          '\$${cartState.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Total (IDR)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                        trailing: Text(
                          formatRupiah(idrTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is! Authenticated) return;

                            final orderId =
                                'ORDER-${DateTime.now().millisecondsSinceEpoch}';

                            try {
                              final result = await di
                                  .sl<PaymentRepository>()
                                  .getSnapToken(
                                    orderId,
                                    idrTotal,
                                    _nameController.text,
                                    _phoneController.text,
                                    _addressController.text,
                                  );

                              result.fold(
                                (failure) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(failure.message)),
                                  );
                                },
                                (snapToken) {
                                  final order = Order(
                                    id: orderId,
                                    userId: authState.user.id,
                                    items: cartState.items,
                                    totalAmount: cartState.totalPrice,
                                    status: 'pending',
                                    createdAt: DateTime.now(),
                                    shippingName: _nameController.text,
                                    shippingAddress: _addressController.text,
                                    shippingPhone: _phoneController.text,
                                  );

                                  if (!mounted) return;
                                  context.read<OrderBloc>().add(
                                    CreateOrder(order),
                                  );
                                  context.read<CartBloc>().add(ClearCart());
                                  context.push(
                                    '/payment?snapToken=$snapToken&orderId=$orderId',
                                  );
                                },
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: const Text('Pay with Midtrans'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatRupiah(num value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
