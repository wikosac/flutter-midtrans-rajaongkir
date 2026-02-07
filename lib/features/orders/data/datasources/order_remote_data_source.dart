import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> createOrder(OrderModel order);
  Future<List<OrderModel>> getUserOrders(String userId);
  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String? transactionId,
  );
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createOrder(OrderModel order) async {
    await firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String? transactionId,
  ) async {
    await firestore.collection('orders').doc(orderId).update({
      'status': status,
      if (transactionId != null) 'transactionId': transactionId,
    });
  }
}
