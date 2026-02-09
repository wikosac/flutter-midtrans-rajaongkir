import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/destination_model.dart';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

abstract class RajaOngkirRemoteDataSource {
  Future<List<DestinationModel>> searchDestinations(String query);
}

class RajaOngkirRemoteDataSourceImpl implements RajaOngkirRemoteDataSource {
  final http.Client client;

  RajaOngkirRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DestinationModel>> searchDestinations(String query) async {
    final response = await client.get(
      Uri.parse(
        'https://rajaongkir.komerce.id/api/v1/destination/domestic-destination?search=$query',
      ),
      headers: {'key': dotenv.env['SHIPPING_COST_API_KEY'] ?? ''},
    );
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final results = data['data'] as List;
      return results.map((json) => DestinationModel.fromJson(json)).toList();
    } else {
      throw Exception(data['meta']['message'] ?? 'Failed to load destinations');
    }
  }
}
