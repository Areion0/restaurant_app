import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/customer_order.dart';
import 'package:restaurant_app/theme/theme_model.dart';

class OrderPanel extends StatelessWidget {
  final CustomerOrder order;

  const OrderPanel({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.pushNamed("/order", arguments: order),
      child: Card(
        // color: ThemeModel.darkBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.date.formattedDateTime, style: ThemeModel.theme.textTheme.bodyMedium),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: order.status.color,
                        size: 20,
                      ),
                      const Gap(10),
                      Text(
                        order.status.name.capitalize,
                        style: ThemeModel.theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Text(
                    order.total.price,
                    style: ThemeModel.theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
