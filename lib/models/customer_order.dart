import 'order_status.dart';

class CustomerOrder {
  final String id;
  final DateTime date;
  final double total;
  final OrderStatus status;
  final List<String> productIDs;
  final String customerID;

  CustomerOrder._({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.productIDs,
    required this.customerID,
  });

  factory CustomerOrder.local({
    required DateTime date,
    required double total,
    required OrderStatus status,
    required List<String> productIDs,
    required String customerID,
  }) =>
      CustomerOrder._(
        id: "",
        date: date,
        total: total,
        status: status,
        productIDs: productIDs,
        customerID: customerID,
      );

  factory CustomerOrder.fromMap(Map<String, dynamic> json, {required String id}) => CustomerOrder._(
        id: id,
        date: DateTime.parse(json["date"] ?? ""),
        total: json["total"] ?? 0.0,
        status: OrderStatus.fromName(json["status"] ?? ""),
        productIDs: List<String>.from(json["products"] ?? []),
        customerID: json["customerID"] ?? "",
      );

  Map<String, dynamic> toMap() {
    var body = {
      "id": id,
      "date": date.toIso8601String(),
      "total": total,
      "status": status.name,
      "products": productIDs,
      "customerID": customerID,
    };

    return body;
  }

  CustomerOrder copyWith({
    String? id,
    DateTime? date,
    double? total,
    OrderStatus? status,
    List<String>? productIDs,
    String? customerID,
  }) =>
      CustomerOrder._(
        id: id ?? this.id,
        date: date ?? this.date,
        total: total ?? this.total,
        status: status ?? this.status,
        productIDs: productIDs ?? this.productIDs,
        customerID: customerID ?? this.customerID,
      );
}
