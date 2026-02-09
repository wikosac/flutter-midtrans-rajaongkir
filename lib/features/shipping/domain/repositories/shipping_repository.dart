import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/destination.dart';

abstract class ShippingRepository {
  Future<Either<Failure, List<Destination>>> searchDestinations(String query);
}
