import 'package:flutter_midtrans/features/products/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.slug,
    required super.name,
    required super.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    slug: json['slug'] as String?,
    name: json['name'] as String?,
    url: json['url'] as String?,
  );

  Map<String, dynamic> toJson() => {'slug': slug, 'name': name, 'url': url};
}