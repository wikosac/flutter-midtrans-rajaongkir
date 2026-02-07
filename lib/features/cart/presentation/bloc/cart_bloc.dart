import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/models/cart_item_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRemoteDataSource remoteDataSource;
  String? userId;

  CartBloc({required this.remoteDataSource})
    : super(const CartState(items: [])) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
    on<SetUserId>(_onSetUserId);
  }

  void _onSetUserId(SetUserId event, Emitter<CartState> emit) {
    userId = event.userId;
    add(LoadCart());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    if (userId == null) return;
    try {
      final items = await remoteDataSource.getCart(userId!);
      log('Loaded cart items: ${items.length}');
      emit(CartState(items: items));
    } catch (e) {
      log('Error loading cart: $e');
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(product: event.product, quantity: 1));
    }

    emit(CartState(items: items));
    if (userId != null) {
      await remoteDataSource.saveCart(
        userId!,
        items
            .map((e) => CartItemModel(product: e.product, quantity: e.quantity))
            .toList(),
      );
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    final items = state.items
        .where((item) => item.product.id != event.productId)
        .toList();
    emit(CartState(items: items));
    if (userId != null) {
      await remoteDataSource.saveCart(
        userId!,
        items
            .map((e) => CartItemModel(product: e.product, quantity: e.quantity))
            .toList(),
      );
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    final items = state.items.map((item) {
      if (item.product.id == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(CartState(items: items));
    if (userId != null) {
      await remoteDataSource.saveCart(
        userId!,
        items
            .map((e) => CartItemModel(product: e.product, quantity: e.quantity))
            .toList(),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(const CartState(items: []));
    if (userId != null) {
      await remoteDataSource.clearCart(userId!);
    }
  }
}
