class SelectedProductModel {
  String product;
  double morningQ;
  double eveningQ;
  String type;
  String price;

  SelectedProductModel(
      {required this.product, required this.morningQ, required this.eveningQ,required this.type,required this.price});

  factory SelectedProductModel.fromJson(Map<String, dynamic> json) {
    return SelectedProductModel(
        product: json["product"],
        morningQ: json["morningQ"],
        type:json["type"],
        price: json["price"],
        eveningQ: json["eveningQ"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'morningQ': morningQ,
      'eveningQ': eveningQ,
      "type":type,
      "price":price
    };
  }
}

List<SelectedProductModel> selectedProduct = [];
