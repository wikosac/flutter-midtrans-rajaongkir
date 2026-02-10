import 'dart:convert';
import 'package:flutter_midtrans/features/products/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String url);
  Future<List<CategoryModel>> getCategories();
  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const baseUrl = 'https://dummyjson.com';

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final jsonList = data['products'] as List;
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String url) async {
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final jsonList = data['products'] as List;
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;
      return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load categories');
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load product');
  }
}
