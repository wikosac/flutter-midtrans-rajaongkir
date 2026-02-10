import '../../domain/entities/shipping_service.dart';

class ShippingServiceModel extends ShippingService {
  const ShippingServiceModel({
    super.shippingName,
    super.serviceName,
    super.weight,
    super.isCod,
    super.shippingCost,
    super.shippingCashback,
    super.shippingCostNet,
    super.grandtotal,
    super.serviceFee,
    super.netIncome,
    super.etd,
  });

  factory ShippingServiceModel.fromJson(Map<String, dynamic> json) {
    return ShippingServiceModel(
      shippingName: json['shipping_name'] as String?,
      serviceName: json['service_name'] as String?,
      weight: json['weight'] as int?,
      isCod: json['is_cod'] as bool?,
      shippingCost: json['shipping_cost'] as int?,
      shippingCashback: json['shipping_cashback'] as int?,
      shippingCostNet: json['shipping_cost_net'] as int?,
      grandtotal: json['grandtotal'] as int?,
      serviceFee: json['service_fee'] as int?,
      netIncome: json['net_income'] as int?,
      etd: json['etd'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'shipping_name': shippingName,
    'service_name': serviceName,
    'weight': weight,
    'is_cod': isCod,
    'shipping_cost': shippingCost,
    'shipping_cashback': shippingCashback,
    'shipping_cost_net': shippingCostNet,
    'grandtotal': grandtotal,
    'service_fee': serviceFee,
    'net_income': netIncome,
    'etd': etd,
  };
}
