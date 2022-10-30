class ProductModel {
  final String name;
  final String price;
  final String id;

  ProductModel({required this.name, required this.price, required this.id});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        name: json['name'], price: json['price'], id: json['id']);
  }
}
