import 'package:flutter/material.dart';
import 'package:restaurant_app/firebase/firestore_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/customer_order.dart';
import 'package:restaurant_app/models/user_model.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/loader.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';
import 'package:restaurant_app/widgets/photos/custom_cached_network_image.dart';
import 'package:restaurant_app/widgets/rectangle_box.dart';

import '../../models/product.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  CustomerOrder? order;

  List<Map<Product, int>> productsWithQuantity = [];

  UserModel? customer;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        if (context.mounted) {
          setState(() {
            order = ModalRoute.of(context)!.settings.arguments as CustomerOrder;
          });
          fetchProducts();
          if (context.authController.user!.isAdmin) fetchCustomerDetails();
        }
      },
    );
  }

  /// Fetch the product details
  Future<void> fetchProducts() async {
    List<Product> products = await FirestoreController.getDocumentsWhereIn("products", "id", order!.productIDs).then(
      (value) => value
          .map(
            (e) => Product.fromMap(e),
          )
          .toList(),
    );

    productsWithQuantity = products
        .map((e) => {
              e: order!.productIDs
                  .where(
                    (element) => element == e.id,
                  )
                  .length
            })
        .toList();
    setState(() {});
  }

  Future<void> fetchCustomerDetails() async {
    customer = await FirestoreController.getDocument("users", order!.customerID).then(
      (value) => UserModel.fromMap(value),
    );
    setState(() {});
  }

  double get rectangleBoxHeight {
    switch (productsWithQuantity.length) {
      case 0:
        return 0;
      case 1:
        return 160;
      case 5:
        return 5 * 80 + 70;
      case > 5:
        return 5 * 75 + 70;
      default:
        return productsWithQuantity.length * 75 + 70;
    }
  }

  double get productListHeight {
    switch (productsWithQuantity.length) {
      case 0:
        return 0;
      case 1:
        return 90;
      case 5:
        return 5 * 80;
      case > 5:
        return 5 * 75;
      default:
        return productsWithQuantity.length * 75;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text(
          order?.date.formattedDateTime ?? "",
          style: ThemeModel.theme.textTheme.titleMedium,
        ),
      ),
      body: PageBlueprint(
        fetching: productsWithQuantity.isEmpty,
        error: order == null,
        child: Center(
          child: RectangleBox(
            height: context.height * 0.85,
            color: ThemeModel.darkGrey,
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.circle,
                      color: order?.status.color,
                      size: 50,
                    ),
                    Text(
                      order?.status.name.capitalize ?? "",
                      style: ThemeModel.theme.textTheme.titleLarge,
                    ),
                  ],
                ),

                // Customer details
                if (context.authController.user!.isAdmin)
                  if (customer == null)
                    const Loader()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RectangleBox(
                        height: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Customer Details",
                              style: ThemeModel.theme.textTheme.titleMedium,
                            ),
                            Text(
                              customer?.displayName ?? "",
                              style: ThemeModel.theme.textTheme.bodyLarge,
                            ),
                            Text(
                              customer?.email ?? "",
                              style: ThemeModel.theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                // List of products
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RectangleBox(
                    height: rectangleBoxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: productListHeight,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productsWithQuantity.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                trailing: Text(
                                  productsWithQuantity[index].keys.first.price.price,
                                  style: ThemeModel.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                                ),
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  child: CustomCachedNetworkImage(
                                      imageUrl: productsWithQuantity[index].keys.first.imageURL ?? ""),
                                ),
                                title: Text(productsWithQuantity[index].keys.first.name),
                                subtitle: Text("x${productsWithQuantity[index].entries.first.value.toString()}"),
                              );
                            },
                          ),
                        ),

                        // Total price
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total: ",
                                style: ThemeModel.theme.textTheme.titleMedium,
                              ),
                              Text(
                                order?.total.price ?? "",
                                style: ThemeModel.theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
