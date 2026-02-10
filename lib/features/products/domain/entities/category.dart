import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? slug;
  final String? name;
  final String? url;

  const Category({this.slug, this.name, this.url});

  @override
  List<Object?> get props => [slug, name, url];
}
