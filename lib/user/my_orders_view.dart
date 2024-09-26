import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/customer_order.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/infinite_list/infinite_list.dart';
import 'package:restaurant_app/widgets/infinite_list/infinite_list_controller.dart';
import 'package:restaurant_app/widgets/orders/order_panel.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../theme/theme_model.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text(
          "My Orders",
          style: ThemeModel.theme.textTheme.titleMedium,
        ),
      ),
      body: PageBlueprint(
        child: ChangeNotifierProvider(
          create: (context) => InfiniteListController<CustomerOrder>(),
          child: InfiniteList<CustomerOrder>(
            collection: "orders",
            filters: {
              "customerID": context.authController.user!.uid,
            },
            loadingText: "Loading orders...",
            itemBuilder: (item, index) => OrderPanel(order: item),
            fromJson: (item, id) => CustomerOrder.fromMap(item, id: id),
            toJson: (object) => object.toMap(),
          ),
        ),
      ),
    );
  }
}
