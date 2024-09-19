// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/cart/cart_item_compact.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../firebase/firestore_controller.dart';
import '../models/customer_order.dart';
import '../models/product.dart';
import 'cart_item.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItemCompact> compactItems = [];

  List<CartItem> get items => _items;

  set items(List<CartItem> value) {
    _items = value;
    compactItems = value.map((e) => CartItemCompact(product: e.product)).toList();
    notifyListeners();
  }

  void add(CartItem item) {
    _items.add(item);
    compactItems.add(CartItemCompact(product: item.product));
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    compactItems.removeWhere((element) => element.product == item.product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    compactItems.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(0, (previousValue, element) => previousValue + element.product.price);

  Future<void> onSubmit(BuildContext context) async {
    List<Product> products = items.map((item) => item.product).toList();

    Logger().i("Sending order with ${products.length} products...");

    await FirestoreController.submitOrder(
      CustomerOrder(
        date: DateTime.now(),
        products: products,
        total: products.fold(0.0, (sum, product) => sum + product.price),
        customerID: "2",
        status: "Test",
      ),
    );

    Fluttertoast.showToast(msg: "✅ Order submitted!");

    if (context.mounted) context.popToHome();

    clear();
  }
}
