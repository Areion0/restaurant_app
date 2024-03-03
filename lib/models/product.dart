class Product {
  late final String name;
  late final String description;
  late final double price;
  String? imageURL;

  Product({required this.name, required this.description, required this.price, this.imageURL});

  Product.fromMap(Map<String, dynamic> map, {this.imageURL}) {
    name = map["Name"];
    description = map["Description"];
    price = map["Price"];
  }
}
