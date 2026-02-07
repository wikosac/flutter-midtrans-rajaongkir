import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/payment_request_model.dart';

abstract class PaymentRemoteDataSource {
  Future<String> getSnapToken(PaymentRequestModel request);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client client;

  PaymentRemoteDataSourceImpl({required this.client});

  @override
  Future<String> getSnapToken(PaymentRequestModel request) async {
    log('Request Body: ${json.encode(request.toJson())}');
    try {
      final response = await client.post(
        Uri.parse('https://nextjs-midtrans-bay.vercel.app/api/transaction'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        throw Exception(
          'Failed to get snap token: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to get snap token: $e');
    }
  }
}
