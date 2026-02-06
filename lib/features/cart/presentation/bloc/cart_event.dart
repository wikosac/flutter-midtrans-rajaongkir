part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;

  UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}
