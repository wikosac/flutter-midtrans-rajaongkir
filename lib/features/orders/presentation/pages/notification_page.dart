import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.green),
            title: const Text('Order Delivered'),
            subtitle: const Text('Your order has been delivered successfully'),
            trailing: const Text('2h ago'),
          ),
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.blue),
            title: const Text('Payment Successful'),
            subtitle: const Text('Your payment has been processed'),
            trailing: const Text('5h ago'),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.orange),
            title: const Text('Order Shipped'),
            subtitle: const Text('Your order is on the way'),
            trailing: const Text('1d ago'),
          ),
        ],
      ),
    );
  }
}
