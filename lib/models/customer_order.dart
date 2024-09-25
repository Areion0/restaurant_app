import 'package:restaurant_app/models/product.dart';

enum OrderStatus { pending, inProgress, completed, cancelled, unknown }

class CustomerOrder {
  final String? id;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final List<Product> products;
  final String customerID;

  CustomerOrder({
    this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.products,
    required this.customerID,
  });

  factory CustomerOrder.fromMap(Map<String, dynamic> json, {required String id}) => CustomerOrder(
        id: id,
        date: DateTime.parse(json['date'] ?? ""),
        total: json['total'] ?? 0.0,
        status: OrderStatus.values.firstWhere(
          (status) => status.name == json['status'],
          orElse: () => OrderStatus.unknown,
        ),
        products: ((json['products'] ?? "") as List).map((product) => Product.fromMap(product)).toList(),
        customerID: json['customerID'] ?? "",
      );

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
