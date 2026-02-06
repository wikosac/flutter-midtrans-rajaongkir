import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<LoadUserOrders>(_onLoadUserOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await repository.createOrder(event.order);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (_) => emit(OrderCreated()),
    );
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    final result = await repository.getUserOrders(event.userId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    final result = await repository.updateOrderStatus(
      event.orderId,
      event.status,
      event.transactionId,
    );
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (_) => add(LoadUserOrders(event.userId)),
    );
  }
}
