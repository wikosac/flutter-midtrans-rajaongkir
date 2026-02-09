part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final int productId;

  LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

class ImageIndexChanged extends ProductDetailEvent {
  final int index;

  ImageIndexChanged(this.index);

  @override
  List<Object> get props => [index];
}
