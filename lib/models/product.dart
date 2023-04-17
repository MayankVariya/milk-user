class ProductModel {
  String? key;
  String? type;
  String? price;

  bool? isSelected;

  ProductModel({required this.key, required this.type, required this.price, this.isSelected});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        key: json["product"], type: json["type"], price: json["price"].toString(),isSelected: false);
  }

  Map<String, dynamic> toMap() {
    return {
      'product': key,
      'type': type,
      'price': price,
      'isSelected':isSelected
    };
  }
}


