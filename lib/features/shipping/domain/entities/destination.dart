import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final int? id;
  final String? label;
  final String? provinceName;
  final String? cityName;
  final String? districtName;
  final String? subdistrictName;
  final String? zipCode;

  const Destination({
    this.id,
    this.label,
    this.provinceName,
    this.cityName,
    this.districtName,
    this.subdistrictName,
    this.zipCode,
  });

  @override
  List<Object?> get props => [id, label, provinceName, cityName, districtName, subdistrictName, zipCode];
}
