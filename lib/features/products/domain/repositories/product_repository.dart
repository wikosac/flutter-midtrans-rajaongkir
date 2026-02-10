import 'package:dartz/dartz.dart';
import 'package:flutter_midtrans/features/products/domain/entities/category.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String url);
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Product>> getProductById(int id);
}
