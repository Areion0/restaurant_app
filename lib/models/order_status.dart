import 'package:flutter/material.dart';

class OrderStatus {
  static const OrderStatus pending = OrderStatus._("pending", Icon(Icons.pending, color: Colors.orange));
  static const OrderStatus processing = OrderStatus._("processing", Icon(Icons.pending, color: Colors.blue));
  static const OrderStatus completed = OrderStatus._("completed", Icon(Icons.check_circle, color: Colors.green));
  static const OrderStatus cancelled = OrderStatus._("cancelled", Icon(Icons.cancel, color: Colors.red));
  static const OrderStatus unknown = OrderStatus._("unknown", Icon(Icons.help, color: Colors.grey));

  final String name;
  final Icon icon;

  static List<OrderStatus> get values => [
        OrderStatus.pending,
        OrderStatus.processing,
        OrderStatus.completed,
        OrderStatus.cancelled,
        OrderStatus.unknown,
      ];

  factory OrderStatus.fromName(String name) {
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
  const OrderStatus._(this.name, this.icon);

  @override
  String toString() {
    return name;
  }
}
