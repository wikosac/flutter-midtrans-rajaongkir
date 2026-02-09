import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/destination_model.dart';
import '../models/shipping_service_model.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

abstract class RajaOngkirRemoteDataSource {
  Future<List<DestinationModel>> searchDestinations(String query);
  Future<List<ShippingServiceModel>> getShippingServices({
    required int shipperDestinationId,
    required int receiverDestinationId,
    required int weight,
    required int itemValue,
  });
}

class RajaOngkirRemoteDataSourceImpl implements RajaOngkirRemoteDataSource {
  final http.Client client;
  final apiKey = dotenv.env['SHIPPING_DELIVERY_API_KEY'] ?? '';
  static const baseUrl =
      'https://api-sandbox.collaborator.komerce.id/tariff/api/v1';

  RajaOngkirRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DestinationModel>> searchDestinations(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/destination/search?keyword=$query'),
      headers: {'x-api-key': apiKey},
    );
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final results = data['data'] as List;
      return results.map((json) => DestinationModel.fromJson(json)).toList();
    } else {
      throw Exception(data['meta']['message'] ?? 'Failed to load destinations');
    }
  }

  @override
  Future<List<ShippingServiceModel>> getShippingServices({
    required int shipperDestinationId,
    required int receiverDestinationId,
    required int weight,
    required int itemValue,
  }) async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl/calculate?shipper_destination_id=$shipperDestinationId&receiver_destination_id=$receiverDestinationId&weight=$weight&item_value=$itemValue',
      ),
      headers: {'x-api-key': apiKey},
    );
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final results = data['data']['calculate_reguler'] as List;
      return results
          .map((json) => ShippingServiceModel.fromJson(json))
          .toList();
    } else {
      throw ServerException(
        data['meta']['message'] ?? 'Failed to load shipping services',
      );
    }
  }
}
