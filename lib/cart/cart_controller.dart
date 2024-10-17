// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/cart_item_compact.dart';
import 'package:restaurant_app/home/home_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../firebase/firestore_controller.dart';
import '../models/customer_order.dart';
import '../models/order_status.dart';
import '../models/product.dart';
import 'cart_item.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  set cartItems(List<CartItem> value) {
    _cartItems = value;
    notifyListeners();
  }

  List<Product> _items = [];
  List<CartItemCompact> compactCartItems = [];

  List<Product> get items => _items;

  set items(List<Product> value) {
    _items = value;

    cartItems = value.map((e) => CartItem(product: e)).toList();
    compactCartItems = value.map((e) => CartItemCompact(product: e)).toList();
    notifyListeners();
  }

  void addProduct(Product item) {
    if (!items.any((element) => element.id == item.id)) {
      cartItems.add(CartItem(product: item));
      compactCartItems.add(CartItemCompact(product: item));
    }

    _items.add(item);
    notifyListeners();
  }

  void removeProduct(Product item) {
    if (items.where((element) => element.id == item.id).length < 2) {
      cartItems.removeWhere((element) => element.product.id == item.id);
      compactCartItems.removeWhere((element) => element.product.id == item.id);
    }

    int productIndex = _items.indexWhere((element) => element.id == item.id);

    if (productIndex != -1) {
      _items.removeAt(productIndex);
    }

    notifyListeners();
  }

  int quantityOfProduct(Product product) => items
      .where(
        (cartItem) => cartItem.id == product.id,
      )
      .length;

  void clear({bool notify = true}) {
    _items.clear();

    cartItems.clear();
    compactCartItems.clear();
    if (notify) notifyListeners();
  }

  double get totalPrice => _items.fold(0, (previousValue, product) => previousValue + product.price);

  Future<void> onSubmit(BuildContext context) async {
    Logger().i("Sending order with ${items.length} products...");

    try {
      await FirestoreController.submitOrder(
        CustomerOrder.local(
          date: DateTime.now(),
          productIDs: items.map((product) => product.id).toList(),
          total: items.fold(0.0, (sum, product) => sum + product.price),
          customerID: context.authController.user!.uid,
          status: OrderStatus.pending,
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "❌ Your order could not be submitted.\nPlease try again later.");
      return;
    }

    Fluttertoast.showToast(msg: "✅ Order submitted!");

    if (context.mounted) {
      context.read<HomeController>().refreshData(context);
      context.popToHome();
    }

    clear();
  }
}
