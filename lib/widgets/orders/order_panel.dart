import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/models/customer_order.dart';
import 'package:restaurant_app/theme/theme_model.dart';

class OrderPanel extends StatelessWidget {
  final CustomerOrder order;

  const OrderPanel({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Logger().i("Order ${order.id} tapped"),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${order.date}"),
              Text(order.status.name.capitalize, style: ThemeModel.theme.textTheme.bodyLarge,),
              Text("Total: ${order.total}"),
            ],
          ),
        ),
      ),
    );
  }
}