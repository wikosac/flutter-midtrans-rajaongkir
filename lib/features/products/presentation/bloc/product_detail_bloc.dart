import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc({required this.repository}) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<ImageIndexChanged>(_onImageIndexChanged);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());
    final result = await repository.getProductById(event.productId);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product, 0)),
    );
  }

  void _onImageIndexChanged(
    ImageIndexChanged event,
    Emitter<ProductDetailState> emit,
  ) {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(ProductDetailLoaded(currentState.product, event.index));
    }
  }
}
