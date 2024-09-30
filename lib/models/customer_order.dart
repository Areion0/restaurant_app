import 'order_status.dart';

class CustomerOrder {
  final String? id;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final List<String> productIDs;
  final String customerID;

  CustomerOrder({
    this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.productIDs,
    required this.customerID,
  });

  factory CustomerOrder.fromMap(Map<String, dynamic> json, {required String id}) => CustomerOrder(
        id: id,
        date: DateTime.parse(json["date"] ?? ""),
        total: json["total"] ?? 0.0,
        status: OrderStatus.fromName(json["status"] ?? ""),
        productIDs: List<String>.from(json["products"] ?? []),
        customerID: json["customerID"] ?? "",
      );

  Map<String, dynamic> toMap() {
    var body = {
      "date": date.toIso8601String(),
      "total": total,
      "status": status.name,
      "products": productIDs,
      "customerID": customerID,
    };

    if (id != null) {
      body["id"] = id!;
    }

    return body;
  }
}
