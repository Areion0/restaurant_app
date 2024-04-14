import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/rectangle_box.dart';

import '../theme/theme_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/page_blueprint.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          title: Text(
            "Checkout",
            style: ThemeModel.theme.textTheme.titleMedium,
          ),
        ),
        body: PageBlueprint(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: context.mediaQuery.size.height * 0.3,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ThemeModel.darkGrey),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RectangleBox(
                        height: 100,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Address
                                  Text(
                                    "Kolokotroni 39",
                                    style: ThemeModel.theme.textTheme.bodyLarge,
                                    textAlign: TextAlign.left,
                                  ),

                                  // City & Postal Code
                                  Text(
                                    "Athens, 105 62",
                                    style: ThemeModel.theme.textTheme.bodyLarge,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Map preview
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeModel.darkBlue,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.edit_location_alt_outlined,
                                  size: 25,
                                  color: ThemeModel.lightGrey,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    // Payment Method
                    RectangleBox(
                      height: 100,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card Number
                                Text(
                                  "**** **** **** 1234",
                                  style: ThemeModel.theme.textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),

                                // Expiry Date
                                Text(
                                  "12/24",
                                  style: ThemeModel.theme.textTheme.bodyLarge,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Card Type?
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ThemeModel.darkBlue,
                          ),
                          child: const Icon(
                            Icons.credit_card_outlined,
                            size: 25,
                            color: ThemeModel.lightGrey,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
}
