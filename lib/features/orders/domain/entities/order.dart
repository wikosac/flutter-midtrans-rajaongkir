import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../shipping/domain/entities/destination.dart';
import 'notification.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String? transactionId;
  final DateTime createdAt;
  final String shippingName;
  final Destination? shippingAddress;
  final String shippingPhone;
  final Notification? lastNotification;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.transactionId,
    required this.createdAt,
    required this.shippingName,
    required this.shippingAddress,
    required this.shippingPhone,
    this.lastNotification,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    totalAmount,
    status,
    transactionId,
    createdAt,
  ];
}
