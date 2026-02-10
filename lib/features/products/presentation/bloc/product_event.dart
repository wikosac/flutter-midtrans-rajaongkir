part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final String url;

  LoadProductsByCategory(this.url);

  @override
  List<Object> get props => [url];
}

class LoadCategories extends ProductEvent {}
