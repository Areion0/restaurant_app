import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/firebase/firestore_controller.dart';
import 'package:restaurant_app/helpers/location.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/rectangle_box.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../theme/theme_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/loader.dart';
import '../widgets/map/map_preview.dart';
import '../widgets/page_blueprint.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late CartController cart;

  Position? userLocation;

  bool loadingMap = true;
  bool gettingAddress = false;

  @override
  void initState() {
    super.initState();

    if (context.authController.user!.streetAddress == null) {
      Future.microtask(() => _getUserLocationData());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    cart = context.watch<CartController>();
  }

  Future<void> _getUserLocationData() async {
    setState(() => gettingAddress = true);

    Map<String, dynamic> locationData =
        await LocationHelper.getCurrentAddress(token: await context.authController.idToken);

    Logger().i("Updating user address data...");

    await Future.wait([
      FirestoreController.updateField(
          collection: "users",
          id: context.authController.user!.uid,
          field: "streetAddress",
          value: locationData["address"]),
      FirestoreController.updateField(
        collection: "users",
        id: context.authController.user!.uid,
        field: "addressLocation",
        value: {"latitude": locationData["position"].latitude, "longitude": locationData["position"].longitude},
      ),
    ]);

    await context.authController.refreshUserData();

    setState(() => gettingAddress = false);
  }

  bool get noAddressFound =>
      context.authController.user!.streetAddress == null || context.authController.user!.streetAddress!.isEmpty;

  String get streetAddress {
    if (noAddressFound) {
      return "Street Address";
    }

    return context.authController.user!.streetAddress!.split(",")[0].trim();
  }

  String get cityPostalCode {
    if (noAddressFound) {
      return "City, Postal Code";
    }

    return context.authController.user!.streetAddress!.split(",")[1].trim();
  }

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
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: context.screenSize.height * 0.3,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ThemeModel.darkGrey),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: RectangleBox(
                        height: 100,
                        child: gettingAddress
                            ? const Center(
                                child: LoaderWithLabel(
                                  color: ThemeModel.darkBlue,
                                  text: "Getting Address...",
                                ),
                              )
                            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                          streetAddress,
                                          style: ThemeModel.theme.textTheme.bodyLarge,
                                          textAlign: TextAlign.left,
                                        ),

                                        // City & Postal Code
                                        Text(
                                          cityPostalCode,
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
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ThemeModel.darkBlue,
                                  ),
                                  child: Stack(
                                    children: [
                                      // Map Preview
                                      Stack(
                                        children: [
                                          MapPreview(
                                            initialLocation: context.authController.user!.addressLocation ??
                                                const LatLng(37.977422, 23.724823),
                                            onMapCreated: () => setState(() => loadingMap = false),
                                          ),
                                          if (loadingMap)
                                            const Center(
                                              child: Loader(
                                                color: ThemeModel.lightGrey,
                                              ),
                                            ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: _getUserLocationData,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: ThemeModel.lightGrey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.edit_location_alt_outlined,
                                                size: 25,
                                                color: ThemeModel.darkBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
            Container(
              height: context.screenSize.height * 0.4,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ThemeModel.darkGrey),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: (context.screenSize.height * 0.4) * 0.65,
                      child: ListView.separated(
                          itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(
                                    top: index == 0 ? 20 : 0,
                                    bottom: index == cart.compactCartItems.length - 1 ? 20 : 0),
                                child: cart.compactCartItems[index],
                              ),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          itemCount: cart.compactCartItems.length),
                    ),

                    // Separator
                    const Divider(
                      color: ThemeModel.lightGrey,
                      thickness: 3,
                    ),

                    // Price Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Items
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dishes",
                                style: ThemeModel.theme.textTheme.bodyLarge?.light,
                              ),
                              Text(
                                cart.totalPrice.price,
                                style: ThemeModel.theme.textTheme.bodyLarge?.light,
                              ),
                            ],
                          ),

                          // VAT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "VAT",
                                  style: ThemeModel.theme.textTheme.bodyLarge?.light,
                                  children: [
                                    TextSpan(
                                      text: "24%",
                                      style: ThemeModel.theme.textTheme.bodySmall?.light,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                (cart.totalPrice * 0.24).price,
                                style: ThemeModel.theme.textTheme.bodyLarge?.light,
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: ThemeModel.theme.textTheme.bodyLarge?.light,
                              ),
                              Text(
                                cart.totalPriceWithTax.price,
                                style: ThemeModel.theme.textTheme.bodyLarge?.light,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit Button
            Container(
                height: 65,
                width: context.screenSize.width * 0.6,
                child: SlideAction(
                  sliderButtonIconPadding: 12,
                  sliderRotate: false,
                  outerColor: gettingAddress ? ThemeModel.darkGrey : ThemeModel.darkBlue,
                  innerColor: ThemeModel.lightGrey,
                  sliderButtonIcon: gettingAddress
                      ? Container(
                          height: 24,
                          width: 24,
                          child: const Loader(
                            color: ThemeModel.darkBlue,
                          ))
                      : null,
                  sliderButtonIconSize: 28,
                  submittedIcon: const Loader(
                    strokeWidth: 5.5,
                  ),
                  enabled: !gettingAddress,
                  onSubmit: () => cart.onSubmit(context),
                  text: "Submit",
                  textStyle: ThemeModel.titleLargeTextStyle.light,
                )),

            const SizedBox()
          ]),
        ),
      );
}
