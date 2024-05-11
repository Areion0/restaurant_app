// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:restaurant_app/cart/cart_item_compact.dart';

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
}
