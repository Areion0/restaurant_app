// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import '../models/product.dart';
import 'cart_item.dart';

class CartController extends ChangeNotifier {
  bool _initialized = false;

  bool get initialized => _initialized;

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  set items(List<CartItem> value) {
    _items = value;
    notifyListeners();
  }

  void add(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void init() {
    _items = List.generate(
      5,
      (index) => CartItem(
        product: Product(
          name: "Product $index",
          description: "Description",
          price: 5,
          image: '',
        ),
      ),
    ).toList();

    initialized = true;
  }
}
