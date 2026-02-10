import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await repository.getProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await repository.getProductsByCategory(event.url);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
