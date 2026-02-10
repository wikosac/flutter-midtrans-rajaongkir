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
