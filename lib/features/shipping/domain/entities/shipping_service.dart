import 'package:equatable/equatable.dart';

class ShippingService extends Equatable {
  final String? shippingName;
  final String? serviceName;
  final int? weight;
  final bool? isCod;
  final int? shippingCost;
  final int? shippingCashback;
  final int? shippingCostNet;
  final int? grandtotal;
  final int? serviceFee;
  final int? netIncome;
  final String? etd;

  const ShippingService({
    this.shippingName,
    this.serviceName,
    this.weight,
    this.isCod,
    this.shippingCost,
    this.shippingCashback,
    this.shippingCostNet,
    this.grandtotal,
    this.serviceFee,
    this.netIncome,
    this.etd,
  });

  @override
  List<Object?> get props => [
    shippingName,
    serviceName,
    weight,
    isCod,
    shippingCost,
    shippingCashback,
    shippingCostNet,
    grandtotal,
    serviceFee,
    netIncome,
    etd,
  ];
}
