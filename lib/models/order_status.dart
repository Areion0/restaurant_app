import 'package:flutter/material.dart';

class OrderStatus {
  static const OrderStatus pending = OrderStatus._("pending", Colors.yellow);
  static const OrderStatus processing = OrderStatus._("processing", Colors.blue);
  static const OrderStatus completed = OrderStatus._("completed", Colors.green);
  static const OrderStatus cancelled = OrderStatus._("cancelled", Colors.red);
  static const OrderStatus unknown = OrderStatus._("unknown", Colors.grey);

  final String name;
  final Color color;

  factory OrderStatus.fromJson(String name) {
    switch (name) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }
  const OrderStatus._(this.name, this.color);

  @override
  String toString() {
    return name;
  }
}
