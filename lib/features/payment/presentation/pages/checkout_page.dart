import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midtrans/features/shipping/domain/entities/destination.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../shipping/data/datasources/rajaongkir_remote_data_source.dart';
import '../../../shipping/data/repositories/shipping_repository_impl.dart';
import '../../../shipping/domain/entities/shipping_service.dart';
import '../../domain/entities/payment_request.dart';
import '../../domain/entities/item_detail.dart';
import '../../domain/entities/transaction_details.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/utils/currency_formatter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _shippingName = '';
  String _shippingPhone = '';
  Destination? _shippingAddress;
  List<ShippingService> _shippingServices = [];
  ShippingService? _selectedService;
  bool _isLoadingServices = false;
  late final ShippingRepositoryImpl _shippingRepository;

  @override
  void initState() {
    super.initState();
    final dataSource = RajaOngkirRemoteDataSourceImpl(client: http.Client());
    _shippingRepository = ShippingRepositoryImpl(remoteDataSource: dataSource);

    final authState = context.read<AuthBloc>().state;
    final cartState = context.read<CartBloc>().state;
    if (authState is Authenticated) {
      _shippingName = authState.user.name;
      _shippingPhone = authState.user.phone ?? '';
      _shippingAddress = authState.user.address;
      _loadShippingServices(
        authState.user.address?.id ?? 0,
        (cartState.totalPrice * 16848).toInt(),
      );
    }
  }

  Future<void> _loadShippingServices(
    int receiverDestinationId,
    int itemValue,
  ) async {
    setState(() {
      _isLoadingServices = true;
    });

    final result = await _shippingRepository.getShippingServices(
      shipperDestinationId: 17477,
      receiverDestinationId: receiverDestinationId,
      weight: 1,
      itemValue: itemValue,
    );

    result.fold(
      (failure) {
        setState(() {
          _isLoadingServices = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (services) {
        setState(() {
          _shippingServices = services;
          _isLoadingServices = false;
        });
      },
    );
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
              _buildShippingInfo(),
              const SizedBox(height: 24),
              _buildShippingServices(),
              const SizedBox(height: 24),
              _buildOrderSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
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
                    Text(_shippingName, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 20),
                    const SizedBox(width: 8),
                    Text(_shippingPhone, style: const TextStyle(fontSize: 16)),
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
                        _shippingAddress?.label ?? '',
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
  }

  Widget _buildShippingServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Service',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _isLoadingServices
            ? const Center(child: CircularProgressIndicator())
            : _shippingServices.isEmpty
            ? const Text('No shipping services available')
            : SizedBox(
                height: 84,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _shippingServices.length,
                  itemBuilder: (context, index) {
                    final service = _shippingServices[index];
                    final isSelected = _selectedService == service;
                    return _buildShippingServiceCard(service, isSelected);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildShippingServiceCard(ShippingService service, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedService = service),
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
        double idrTotal = cartState.totalPrice * 16848;
        double shippingCost = _selectedService?.shippingCost?.toDouble() ?? 0;
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
            if (_selectedService != null) ...[
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
            _buildPaymentButton(cartState, idrTotal),
          ],
        );
      },
    );
  }

  Widget _buildPaymentButton(CartState cartState, double idrTotal) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedService == null
            ? null
            : () => _processPayment(cartState, idrTotal),
        child: const Text('Pay with Midtrans'),
      ),
    );
  }

  Future<void> _processPayment(CartState cartState, double idrTotal) async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';

    try {
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

      final result = await di.sl<PaymentRepository>().getSnapToken(request);

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (snapToken) {
          final order = Order(
            id: orderId,
            userId: authState.user.id,
            items: cartState.items,
            totalAmount: cartState.totalPrice,
            status: 'pending',
            transactionId: snapToken,
            createdAt: DateTime.now(),
            shippingName: _shippingName,
            shippingAddress: authState.user.address,
            shippingPhone: _shippingPhone,
          );

          if (!mounted) return;
          context.read<OrderBloc>().add(CreateOrder(order));
          context.read<CartBloc>().add(ClearCart());
          context.pushReplacement(
            '/payment?snapToken=$snapToken&orderId=$orderId',
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
