import 'package:equatable/equatable.dart';
import 'package:flutter_midtrans/features/shipping/domain/entities/destination.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final Destination? address;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
  });

  @override
  List<Object?> get props => [id, email, name, phone, address];
}
