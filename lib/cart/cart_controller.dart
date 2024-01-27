// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import 'cart_item.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

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
}