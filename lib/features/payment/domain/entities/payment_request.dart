import 'item_detail.dart';
import 'transaction_details.dart';

class PaymentRequest {
  TransactionDetails transactionDetails;
  List<ItemDetail> itemDetails;

  PaymentRequest({required this.transactionDetails, required this.itemDetails});

  Map<String, dynamic> toJson() => {
    'transaction_details': transactionDetails.toJson(),
    'item_details': itemDetails.map((e) => e.toJson()).toList(),
  };
}
