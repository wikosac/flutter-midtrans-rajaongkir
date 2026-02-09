import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/destination.dart';
import '../entities/shipping_service.dart';

abstract class ShippingRepository {
  Future<Either<Failure, List<Destination>>> searchDestinations(String query);
  Future<Either<Failure, List<ShippingService>>> getShippingServices({
    required int shipperDestinationId,
    required int receiverDestinationId,
    required int weight,
    required int itemValue,
  });
}
