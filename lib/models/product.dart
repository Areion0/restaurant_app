class Product {
  late final String name;
  late final String description;
  late final double price;
  String? imageID;
  String? imageURL;

  Product({required this.name, required this.description, required this.price, this.imageURL});

  Product.fromMap(Map<String, dynamic> map, {this.imageURL}) {
    name = map["name"];
    description = map["description"] ?? "";
    price = map["price"];
    imageID = map["imageID"];
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "price": price,
        "imageID": imageID ?? "",
        "imageURL": imageURL ?? "",
      };
}
