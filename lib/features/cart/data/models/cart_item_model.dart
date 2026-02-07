import '../../domain/entities/cart_item.dart';
import '../../../products/data/models/product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productMap = json['product'] as Map<String, dynamic>;
    return CartItemModel(
      product: ProductModel(
        id: productMap['id'] as int,
        title: productMap['title'] as String,
        price: (productMap['price'] as num).toDouble(),
        description: productMap['description'] as String,
        category: productMap['category'] as String,
        images: List<String>.from(productMap['images'] as List),
      ),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'images': product.images,
      },
      'quantity': quantity,
    };
  }
}
