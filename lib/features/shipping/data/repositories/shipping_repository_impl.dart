import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/destination.dart';
import '../../domain/repositories/shipping_repository.dart';
import '../datasources/rajaongkir_remote_data_source.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final RajaOngkirRemoteDataSource remoteDataSource;

  ShippingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Destination>>> searchDestinations(
    String query,
  ) async {
    try {
      final destinations = await remoteDataSource.searchDestinations(query);
      return Right(destinations);
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }
}
