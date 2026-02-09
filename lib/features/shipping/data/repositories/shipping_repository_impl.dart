import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/shipping_service.dart';
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

  @override
  Future<Either<Failure, List<ShippingService>>> getShippingServices({
    required int shipperDestinationId,
    required int receiverDestinationId,
    required int weight,
    required int itemValue,
  }) async {
    try {
      final services = await remoteDataSource.getShippingServices(
        shipperDestinationId: shipperDestinationId,
        receiverDestinationId: receiverDestinationId,
        weight: weight,
        itemValue: itemValue,
      );
      return Right(services);
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch shipping services: ${e.toString()}'),
      );
    }
  }
}
