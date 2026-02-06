part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final int categoryId;

  LoadProductsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class LoadCategories extends ProductEvent {}
