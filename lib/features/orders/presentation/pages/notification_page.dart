import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';
import '../../../../core/utils/currency_formatter.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Center(child: Text('Please login'));
          }

          context.read<OrderBloc>().add(LoadUserOrders(authState.user.id));

          return BlocBuilder<OrderBloc, OrderState>(
            builder: (context, orderState) {
              if (orderState is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (orderState is OrderError) {
                return Center(child: Text(orderState.message));
              }

              if (orderState is OrdersLoaded) {
                final ordersWithNotifications = orderState.orders
                    .where((order) => order.lastNotification != null)
                    .toList();

                if (ordersWithNotifications.isEmpty) {
                  return const Center(child: Text('No notifications'));
                }

                return ListView.builder(
                  itemCount: ordersWithNotifications.length,
                  itemBuilder: (context, index) {
                    final order = ordersWithNotifications[index];
                    final notification = order.lastNotification!;
                    return _buildNotificationTile(order, notification);
                  },
                );
              }

              return const Center(child: Text('No notifications'));
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(Order order, notification) {
    IconData icon;
    Color color;
    String title;
    String subtitle;

    switch (notification.transactionStatus?.toLowerCase()) {
      case 'settlement':
      case 'capture':
        icon = Icons.check_circle;
        color = Colors.green;
        title = 'Payment Successful';
        subtitle = '${order.id} - ${notification.paymentType}';
        break;
      case 'pending':
        icon = Icons.pending;
        color = Colors.orange;
        title = 'Payment Pending';
        subtitle = '${order.id} - ${notification.paymentType}';
        break;
      case 'deny':
      case 'cancel':
      case 'expire':
        icon = Icons.cancel;
        color = Colors.red;
        title = 'Payment ${notification.transactionStatus}';
        subtitle = order.id;
        break;
      default:
        icon = Icons.info;
        color = Colors.blue;
        title = 'Transaction Update';
        subtitle = order.id;
    }

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          if (notification.grossAmount != null)
            Text(
              'Amount: ${formatRupiah(double.parse(notification.grossAmount!))}',
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      trailing: notification.transactionTime != null
          ? Text(
              _formatTime(notification.transactionTime!),
              style: const TextStyle(fontSize: 12),
            )
          : null,
    );
  }

  String _formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return '';
    }
  }
}
