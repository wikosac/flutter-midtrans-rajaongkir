import '../../../cart/domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    super.transactionId,
    required super.createdAt,
    required super.shippingName,
    required super.shippingAddress,
    required super.shippingPhone,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map(
            (item) => CartItem(
              product: ProductModel.fromJson(item['product']),
              quantity: item['quantity'],
            ),
          )
          .toList(),
      totalAmount: json['totalAmount'],
      status: json['status'],
      transactionId: json['transactionId'],
      createdAt: DateTime.parse(json['createdAt']),
      shippingName: json['shippingName'],
      shippingAddress: json['shippingAddress'],
      shippingPhone: json['shippingPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items
          .map(
            (item) => {
              'product': {
                'id': item.product.id,
                'title': item.product.title,
                'price': item.product.price,
                'description': item.product.description,
                'category': item.product.category,
                'images': item.product.images,
              },
              'quantity': item.quantity,
            },
          )
          .toList(),
      'totalAmount': totalAmount,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'shippingName': shippingName,
      'shippingAddress': shippingAddress,
      'shippingPhone': shippingPhone,
    };
  }
}
