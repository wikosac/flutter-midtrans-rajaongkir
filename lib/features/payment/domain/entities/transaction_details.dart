class TransactionDetails {
  String? orderId;
  int? grossAmount;

  TransactionDetails({this.orderId, this.grossAmount});

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'gross_amount': grossAmount,
  };
}
