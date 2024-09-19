import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_elevated_button.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late CartController cart;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    cart = context.watch<CartController>();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          title: Text(
            "Order Summary",
            style: ThemeModel.theme.textTheme.titleMedium,
          ),
          icon: const Icon(Icons.remove_shopping_cart_outlined, color: ThemeModel.darkRed, size: 35),
          onIconPressed: () {
            cart.clear();
            if (cart.items.isEmpty) context.pop();
          },
        ),
        body: PageBlueprint(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: context.mediaQuery.size.height * 0.7,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ThemeModel.darkGrey),
                      child: cart.items.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your cart is empty",
                                    style: TextStyle(
                                      color: ThemeModel.lightGrey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    color: ThemeModel.lightGrey,
                                    size: 50,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(
                                        top: index == 0 ? 20 : 0, bottom: index == cart.items.length - 1 ? 20 : 0),
                                    child: cart.items[index],
                                  ),
                              separatorBuilder: (context, index) => const SizedBox(
                                    height: 20,
                                  ),
                              itemCount: cart.items.length),
                    ),
                    SizedBox(height: context.mediaQuery.size.height * 0.04),
                    Container(
                      height: 65,
                      width: context.mediaQuery.size.width * 0.6,
                      child: CustomElevatedButton(
                        onPressed: cart.items.isEmpty ? null : () => context.pushNamed("/checkout"),
                        child: const Text("Checkout"),
                      ),
                    ),
                  ],
                )
              ],
            )),
      );
}
