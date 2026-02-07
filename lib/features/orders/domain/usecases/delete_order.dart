import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class DeleteOrder implements UseCase<void, String> {
  final OrderRepository repository;

  DeleteOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(String orderId) async {
    return await repository.deleteOrder(orderId);
  }
}
