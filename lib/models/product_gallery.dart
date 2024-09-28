import 'package:restaurant_app/models/gallery_type.dart';

import 'product.dart';

class ProductGallery {
  final GalleryType type;

  final List<Product> products;

  ProductGallery({
    required this.type,
    required this.products,
  });
}
