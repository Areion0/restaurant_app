import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const CartItem({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(item["name"]));
  }
}
