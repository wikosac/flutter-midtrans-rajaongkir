part of 'product_detail_bloc.dart';

abstract class ProductDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final int currentImageIndex;

  ProductDetailLoaded(this.product, this.currentImageIndex);

  @override
  List<Object> get props => [product, currentImageIndex];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}
