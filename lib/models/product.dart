class Product {
  late final String name;
  late final String description;
  late final double price;
  late final String image;

  Product({required this.name, required this.description, required this.price, required this.image});

  Product.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    description = map["description"];
    price = map["price"];
    image = map["image"];
  }
}
