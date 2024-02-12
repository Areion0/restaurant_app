import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/appbar.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late CartController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller = context.watch<CartController>();

    if (!controller.initialized) controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBlueprint(
          child: Column(
        children: [
          const CartAppbar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Container(
                  height: context.mediaQuery.size.height * 0.7,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ThemeModel.darkGrey),
                  child: ListView.separated(
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                                top: index == 0 ? 20 : 0, bottom: index == controller.items.length - 1 ? 20 : 0),
                            child: controller.items[index],
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 20,
                          ),
                      itemCount: controller.items.length),
                ),
                SizedBox(height: context.mediaQuery.size.height * 0.04),
                Container(
                  height: 65,
                  width: context.mediaQuery.size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
