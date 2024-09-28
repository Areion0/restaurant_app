class Product {
  late final String id;
  late final String name;
  late final String description;
  late final double price;
  String? imageURL;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageURL,
  });

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map["id"] ?? "",
        name: map["name"],
        description: map["description"] ?? "",
        price: map["price"],
        imageURL: map["imageURL"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "price": price,
        "imageURL": imageURL ?? "",
      };
}
