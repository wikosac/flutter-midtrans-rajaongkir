part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({required this.items});

  double get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get idrTotalPrice =>
      items.fold(0, (sum, item) => sum + item.idrTotalPrice);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [items];
}
