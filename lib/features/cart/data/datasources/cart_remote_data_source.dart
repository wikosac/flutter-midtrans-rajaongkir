import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<void> saveCart(String userId, List<CartItemModel> items);
  Future<List<CartItemModel>> getCart(String userId);
  Future<void> clearCart(String userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> saveCart(String userId, List<CartItemModel> items) async {
    await firestore.collection('carts').doc(userId).set({
      'items': items.map((item) => item.toJson()).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<CartItemModel>> getCart(String userId) async {
    final doc = await firestore.collection('carts').doc(userId).get();
    if (!doc.exists) return [];
    final data = doc.data()!;
    return (data['items'] as List)
        .map((item) => CartItemModel.fromJson(item))
        .toList();
  }

  @override
  Future<void> clearCart(String userId) async {
    await firestore.collection('carts').doc(userId).delete();
  }
}
