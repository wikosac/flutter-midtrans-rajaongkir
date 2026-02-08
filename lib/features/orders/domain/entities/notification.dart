class Notification {
  String? statusCode;
  String? transactionId;
  String? grossAmount;
  String? currency;
  String? orderId;
  String? paymentType;
  String? signatureKey;
  String? transactionStatus;
  String? fraudStatus;
  String? statusMessage;
  String? merchantId;
  String? transactionTime;
  String? settlementTime;
  String? expiryTime;

  Notification({
    this.statusCode,
    this.transactionId,
    this.grossAmount,
    this.currency,
    this.orderId,
    this.paymentType,
    this.signatureKey,
    this.transactionStatus,
    this.fraudStatus,
    this.statusMessage,
    this.merchantId,
    this.transactionTime,
    this.settlementTime,
    this.expiryTime,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    statusCode: json['status_code'] as String?,
    transactionId: json['transaction_id'] as String?,
    grossAmount: json['gross_amount'] as String?,
    currency: json['currency'] as String?,
    orderId: json['order_id'] as String?,
    paymentType: json['payment_type'] as String?,
    signatureKey: json['signature_key'] as String?,
    transactionStatus: json['transaction_status'] as String?,
    fraudStatus: json['fraud_status'] as String?,
    statusMessage: json['status_message'] as String?,
    merchantId: json['merchant_id'] as String?,
    transactionTime: json['transaction_time'] as String?,
    settlementTime: json['settlement_time'] as String?,
    expiryTime: json['expiry_time'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'status_code': statusCode,
    'transaction_id': transactionId,
    'gross_amount': grossAmount,
    'currency': currency,
    'order_id': orderId,
    'payment_type': paymentType,
    'signature_key': signatureKey,
    'transaction_status': transactionStatus,
    'fraud_status': fraudStatus,
    'status_message': statusMessage,
    'merchant_id': merchantId,
    'transaction_time': transactionTime,
    'settlement_time': settlementTime,
    'expiry_time': expiryTime,
  };
}
