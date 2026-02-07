class TransactionDetails {
  String? orderId;
  int? grossAmount;

  TransactionDetails({this.orderId, this.grossAmount});

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      orderId: json['order_id'] as String?,
      grossAmount: json['gross_amount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'gross_amount': grossAmount,
  };
}
