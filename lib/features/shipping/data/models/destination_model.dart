import '../../domain/entities/destination.dart';

class DestinationModel extends Destination {
  const DestinationModel({
    super.id,
    super.label,
    super.provinceName,
    super.cityName,
    super.districtName,
    super.subdistrictName,
    super.zipCode,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) =>
      DestinationModel(
        id: json['id'] as int?,
        label: json['label'] as String?,
        provinceName: json['province_name'] as String?,
        cityName: json['city_name'] as String?,
        districtName: json['district_name'] as String?,
        subdistrictName: json['subdistrict_name'] as String?,
        zipCode: json['zip_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'province_name': provinceName,
    'city_name': cityName,
    'district_name': districtName,
    'subdistrict_name': subdistrictName,
    'zip_code': zipCode,
  };

  factory DestinationModel.fromEntity(Destination destination) {
    return DestinationModel(
      id: destination.id,
      label: destination.label,
      provinceName: destination.provinceName,
      cityName: destination.cityName,
      districtName: destination.districtName,
      subdistrictName: destination.subdistrictName,
      zipCode: destination.zipCode,
    );
  }
}
