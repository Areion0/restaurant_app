import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../firebase/firestore_controller.dart';
import '../models/customer_order.dart';
import '../models/gallery_type.dart';
import '../models/product.dart';
import '../models/product_gallery.dart';

class HomeController extends ChangeNotifier {
  bool firstTime = true;

  bool _fetching = true;
  bool get fetching => _fetching;
  set fetching(bool value) {
    _fetching = value;
    notifyListeners();
  }

  List<ProductGallery> _galleries = [];
  List<ProductGallery> get galleries => _galleries;
  set galleries(List<ProductGallery> value) {
    _galleries = value;
    notifyListeners();
  }

  ProductGallery? _recentOrdersGallery;
  ProductGallery? get recentOrdersGallery => _recentOrdersGallery;
  set recentOrdersGallery(ProductGallery? value) {
    _recentOrdersGallery = value;
    notifyListeners();
  }

  Future<void> prepareGalleries(BuildContext context) async {
    Logger logger = Logger();
    try {
      galleries = await FirestoreController.getProductGalleries(context);
      await prepareRecentOrdersGallery();
    } on Exception catch (e) {
      logger.e("Failed to get products: $e");
    } finally {
      fetching = false;
    }
  }

  Future<void> prepareRecentOrdersGallery({int limit = 5}) async {
    Logger logger = Logger();
    try {
      List<CustomerOrder> orders = await FirestoreController.fetchMyOrders();

      final productIDs = <String>{};
      List<String> productsToFetch = orders.expand((order) => order.productIDs).toList();
      productsToFetch.retainWhere((product) => productIDs.add(product));
      productsToFetch = productsToFetch.sublist(0, limit > productsToFetch.length ? productsToFetch.length : limit);

      if (productsToFetch.isEmpty) {
        recentOrdersGallery = null;
        return;
      }

      List<Product> products = await FirebaseFirestore.instance
          .collection("products")
          .where("id", whereIn: productsToFetch)
          .get()
          .then((snapshot) => snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());

      recentOrdersGallery = ProductGallery(
        type: GalleryType.recentOrders,
        products: products,
      );
    } on Exception catch (e) {
      logger.e("Failed to get recent orders: $e");
    }
  }

  void refreshData(BuildContext context) {
    fetching = true;
    prepareGalleries(context);
  }

  void reset() {
    firstTime = true;
    _fetching = true;
    _galleries = [];
    _recentOrdersGallery = null;
  }
}
