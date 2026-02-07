class ItemDetail {
  String? id;
  int? price;
  int? quantity;
  String? name;
  String? brand;
  String? category;
  String? merchantName;
  String? url;

  ItemDetail({
    this.id,
    this.price,
    this.quantity,
    this.name,
    this.brand,
    this.category,
    this.merchantName,
    this.url,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
    id: json['id'] as String?,
    price: json['price'] as int?,
    quantity: json['quantity'] as int?,
    name: json['name'] as String?,
    brand: json['brand'] as String?,
    category: json['category'] as String?,
    merchantName: json['merchant_name'] as String?,
    url: json['url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'price': price,
    'quantity': quantity,
    'name': name,
    'brand': brand,
    'category': category,
    'merchant_name': merchantName,
    'url': url,
  };
}
