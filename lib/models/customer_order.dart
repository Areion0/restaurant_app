import 'package:restaurant_app/models/product.dart';

enum OrderStatus { pending, inProgress, completed, cancelled }

class CustomerOrder {
  CustomerOrder({
    this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.products,
    required this.customerID,
  });

  final String? id;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final List<Product> products;
  final String customerID;

  Map<String, dynamic> toMap() {
    var body = {
      'date': date.toIso8601String(),
      'total': total,
      'status': status.name,
      'products': products.map((product) => product.toMap()).toList(),
      'customerID': customerID,
    };

    if (id != null) {
      body['id'] = id!;
    }

    return body;
  }
}
