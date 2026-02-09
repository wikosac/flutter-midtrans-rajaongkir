import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) =>
                      _buildCartItem(context, state.items[index]),
                ),
              ),
              _buildCartSummary(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: item.product.images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Category: ${item.product.category}'),
                  Text('\$${item.product.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 4),
                  _buildQuantityControls(context, item),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => context.read<CartBloc>().add(
                    RemoveFromCart(item.product.id),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem item) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 20),
          onPressed: () {
            if (item.quantity > 1) {
              context.read<CartBloc>().add(
                UpdateQuantity(item.product.id, item.quantity - 1),
              );
            }
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('${item.quantity}'),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 20),
          onPressed: () => context.read<CartBloc>().add(
            UpdateQuantity(item.product.id, item.quantity + 1),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildCartSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${state.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleCheckout(context),
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      if (user.phone == null || user.phone!.isEmpty || user.address == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Complete Your Profile'),
            content: const Text(
              'Please add your phone number and address before checkout.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/edit-profile');
                },
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        );
      } else {
        context.push('/checkout');
      }
    }
  }
}
