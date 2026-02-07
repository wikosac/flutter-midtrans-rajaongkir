part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final Order order;

  CreateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class LoadUserOrders extends OrderEvent {
  final String userId;

  LoadUserOrders(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;
  final String? transactionId;
  final String userId;

  UpdateOrderStatus(
    this.orderId,
    this.status,
    this.userId, {
    this.transactionId,
  });

  @override
  List<Object?> get props => [orderId, status, transactionId, userId];
}

class DeleteOrder extends OrderEvent {
  final String orderId;
  final String userId;

  DeleteOrder(this.orderId, this.userId);

  @override
  List<Object> get props => [orderId, userId];
}
