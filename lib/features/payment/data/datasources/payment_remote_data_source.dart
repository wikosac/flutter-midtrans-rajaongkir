import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class PaymentRemoteDataSource {
  Future<String> getSnapToken(
    String orderId,
    double amount,
    String name,
    String phone,
    String address,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client client;

  PaymentRemoteDataSourceImpl({required this.client});

  @override
  Future<String> getSnapToken(
    String orderId,
    double amount,
    String name,
    String phone,
    String address,
  ) async {
    final response = await client.post(
      Uri.parse('https://nextjs-midtrans-bay.vercel.app/api'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "id": orderId,
        "productName": name,
        "price": amount,
        "quantity": 1,
      }),
      // body: json.encode({
      //   'transaction_details': {
      //     'order_id': orderId,
      //     'gross_amount': amount.toInt(),
      //   },
      //   'customer_details': {
      //     'first_name': name,
      //     'phone': phone,
      //     'shipping_address': {'address': address},
      //   },
      // }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['token'];
    }
    throw Exception('Failed to get snap token');
  }
}
