import '../../domain/entities/item_detail.dart';
import '../../domain/entities/payment_request.dart';
import '../../domain/entities/transaction_details.dart';

class PaymentRequestModel extends PaymentRequest {
  PaymentRequestModel({
    required super.transactionDetails,
    required super.itemDetails,
  });

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      transactionDetails: TransactionDetails.fromJson(
        json['transaction_details'] as Map<String, dynamic>,
      ),
      itemDetails: (json['item_details'] as List<dynamic>)
          .map((e) => ItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'transaction_details': transactionDetails.toJson(),
    'item_details': itemDetails.map((e) => e.toJson()).toList(),
  };
}
