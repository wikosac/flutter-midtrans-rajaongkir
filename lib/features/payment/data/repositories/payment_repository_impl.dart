import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> getSnapToken(String orderId, double amount, String name, String phone, String address) async {
    try {
      final token = await remoteDataSource.getSnapToken(orderId, amount, name, phone, address);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
