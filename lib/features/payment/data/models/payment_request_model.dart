import '../../domain/entities/payment_request.dart';

class PaymentRequestModel extends PaymentRequest {
  PaymentRequestModel({
    required super.transactionDetails,
    required super.itemDetails,
  });

  @override
  Map<String, dynamic> toJson() => {
    'transaction_details': transactionDetails.toJson(),
    'item_details': itemDetails.map((e) => e.toJson()).toList(),
  };
}
