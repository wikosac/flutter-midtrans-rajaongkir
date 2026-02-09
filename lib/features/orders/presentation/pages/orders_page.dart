import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midtrans/features/orders/domain/entities/order.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/order_bloc.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<OrderBloc>().add(LoadUserOrders(authState.user.id));
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      case 'processing':
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yet'));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) =>
                  _buildOrderCard(state.orders[index]),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        leading: Icon(
          _getStatusIcon(order.status),
          color: _getStatusColor(order.status),
          size: 32,
        ),
        title: Text('Order #${order.id.substring(order.id.length - 8)}'),
        subtitle: _buildOrderSummary(order),
        children: [_buildOrderDetails(order)],
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              _getStatusIcon(order.status),
              size: 16,
              color: _getStatusColor(order.status),
            ),
            const SizedBox(width: 4),
            Text(
              'Status: ${order.status.toUpperCase()}',
              style: TextStyle(
                color: _getStatusColor(order.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
        Text('Date: ${order.createdAt.toString().split('.')[0]}'),
      ],
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          _buildOrderStatus(order),
          const SizedBox(height: 16),
          _buildShippingInfo(order),
          const SizedBox(height: 16),
          _buildOrderItems(order),
          const Divider(),
          _buildTotalAmount(order),
          if (order.status.toLowerCase() == 'pending' &&
              order.transactionId != null)
            ActionButton(order: order),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Status',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.payment, color: _getStatusColor(order.status)),
            const SizedBox(width: 8),
            Text('Payment: ${order.status}'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.local_shipping,
              color: order.status == 'paid' ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Shipping: ${order.status == 'paid' ? 'Processing' : 'Pending'}',
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.home,
              color: order.status == 'completed' ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Delivery: ${order.status == 'completed' ? 'Delivered' : 'Not yet'}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingInfo(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Name'),
          subtitle: Text(order.shippingName),
          dense: true,
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Phone'),
          subtitle: Text(order.shippingPhone),
          dense: true,
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Address'),
          subtitle: Text(order.shippingAddress?.label ?? 'N/A'),
          dense: true,
        ),
      ],
    );
  }

  Widget _buildOrderItems(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...order.items.map(
          (item) => ListTile(
            title: Text(item.product.title),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount(Order order) {
    return ListTile(
      title: const Text(
        'Total Amount',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        '\$${order.totalAmount.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cancel Order'),
                    content: const Text(
                      'Are you sure you want to cancel this order?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<OrderBloc>().add(
                      DeleteOrder(order.id, authState.user.id),
                    );
                  }
                }
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.push(
                  '/payment?snapToken=${order.transactionId}&orderId=${order.id}',
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Pay Now'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
