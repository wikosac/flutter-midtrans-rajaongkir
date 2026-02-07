import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> getSnapToken(String orderId, double amount, String name, String phone, String address);
}
