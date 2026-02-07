import '../../../cart/domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';
import '../../../shipping/data/models/destination_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/notification.dart';

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
    super.lastNotification,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>).map((item) {
        final itemMap = item as Map<String, dynamic>;
        final productMap = itemMap['product'] as Map<String, dynamic>;
        return CartItem(
          product: ProductModel(
            id: productMap['id'] as int,
            title: productMap['title'] as String,
            price: (productMap['price'] as num).toDouble(),
            description: productMap['description'] as String,
            category: productMap['category'] as String,
            images: List<String>.from(productMap['images'] as List),
          ),
          quantity: itemMap['quantity'] as int,
        );
      }).toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      shippingName: json['shippingName'] as String,
      shippingAddress: json['shippingAddress'] != null
          ? DestinationModel.fromJson(json['shippingAddress'] as Map<String, dynamic>)
          : null,
      shippingPhone: json['shippingPhone'] as String,
      lastNotification: json['lastNotification'] != null
          ? Notification.fromJson(
              json['lastNotification'] as Map<String, dynamic>,
            )
          : null,
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
      'shippingAddress': shippingAddress != null
          ? DestinationModel.fromEntity(shippingAddress!).toJson()
          : null,
      'shippingPhone': shippingPhone,
      'lastNotification': lastNotification?.toJson(),
    };
  }
}
