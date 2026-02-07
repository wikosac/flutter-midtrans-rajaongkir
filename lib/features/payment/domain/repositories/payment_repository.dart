import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_request.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> getSnapToken(PaymentRequest request);
}
