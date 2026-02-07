import 'item_detail.dart';
import 'transaction_details.dart';

class PaymentRequest {
  TransactionDetails transactionDetails;
  List<ItemDetail> itemDetails;

  PaymentRequest({required this.transactionDetails, required this.itemDetails});

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
    transactionDetails: TransactionDetails.fromJson(
      json['transaction_details'] as Map<String, dynamic>,
    ),
    itemDetails: (json['item_details'] as List<dynamic>)
        .map((e) => ItemDetail.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'transaction_details': transactionDetails.toJson(),
    'item_details': itemDetails.map((e) => e.toJson()).toList(),
  };
}
