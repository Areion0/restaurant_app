import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
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

import '../../models/order_status.dart';
import '../../models/product.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  CustomerOrder? order;
  FutureOr<void> Function()? onRefresh;

  List<Map<Product, int>> productsWithQuantity = [];

  UserModel? customer;

  bool updatingStatus = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        if (context.mounted) {
          final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
          setState(() {
            order = args[0] as CustomerOrder;
          });
          onRefresh = args[1] as FutureOr<void> Function();
          fetchProducts();
          if (context.authController.user!.isAdmin) fetchCustomerDetails();
        }
      },
    );
  }

  Future<void> fetchProducts() async {
    List<Product> totalProducts =
        await FirestoreController.getDocumentsWhereIn("products", "id", order!.productIDs).then(
      (value) => value
          .map(
            (e) => Product.fromMap(e),
          )
          .toList(),
    );

    productsWithQuantity = totalProducts
        .map((product) => {
              product: order!.productIDs
                  .where(
                    (productID) => productID == product.id,
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
          icon: const Icon(
            Icons.delete,
            color: ThemeModel.darkRed,
          ),
          onIconPressed: onDeleteOrderPressed),
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
                if (updatingStatus)
                  const Loader()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton.icon(
                      onPressed: context.authController.user!.isAdmin ? onUpdateStatusPressed : null,
                      style: ThemeModel.theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStateProperty.all(ThemeModel.lightGrey),
                        overlayColor: WidgetStateProperty.all(ThemeModel.darkBlue.withOpacity(0.1)),
                      ),
                      icon: context.authController.user!.isAdmin
                          ? const Icon(
                              Icons.edit,
                              color: ThemeModel.darkBlue,
                            )
                          : null,
                      iconAlignment: IconAlignment.end,
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            order?.status.icon.withSize(50) ?? const Gap(0),
                            Text(
                              order?.status.name.capitalize ?? "",
                              style: ThemeModel.theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Customer details
                if (context.authController.user!.isAdmin)
                  if (customer == null)
                    const Loader()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: RectangleBox(
                        height: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Customer Details",
                              style: ThemeModel.theme.textTheme.titleMedium,
                            ),
                            Text(
                              customer?.displayName ?? "",
                              style: ThemeModel.theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              customer?.email ?? "",
                              style: ThemeModel.theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
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

  Future<void> onUpdateStatusPressed() async => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Change status", style: ThemeModel.theme.textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: OrderStatus.values
                  .map(
                    (status) => ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabled: status.name != order!.status.name,
                      leading:
                          status.name == order!.status.name ? status.icon.withColor(ThemeModel.darkGrey) : status.icon,
                      title: Text(
                        status.name.capitalize,
                      ),
                      onTap: () {
                        Logger().i("Changing status to ${status.name}");

                        updateOrderStatus(status);

                        context.pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

  void updateOrderStatus(OrderStatus status) async {
    Logger logger = Logger();
    setState(() {
      updatingStatus = true;
    });
    try {
      await FirestoreController.updateField(
          collection: "users/${order!.customerID}/orders", id: order!.id, field: "status", value: status.name);
      logger.i("Order status updated successfully");
      Fluttertoast.showToast(msg: "✅ Order status updated successfully!");
    } on Exception catch (e, s) {
      logger.e("Failed to update order status: ${e.toString()}");
      logger.e(s);
      Fluttertoast.showToast(msg: "❌ Failed to update order status, please try again later.");
      return;
    } finally {
      setState(() {
        updatingStatus = false;
      });
    }

    if (!context.mounted) return;
    setState(() {
      order = order!.copyWith(status: status);
    });

    await onRefresh?.call();
  }

  void onDeleteOrderPressed() async => showDialog(
        context: context,
        builder: (context) {
          bool deletingOrder = false;

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Delete order", style: ThemeModel.theme.textTheme.titleLarge),
              content: const Text("Are you sure you want to delete this order?"),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: deletingOrder ? ThemeModel.darkGrey : ThemeModel.darkRed,
                  ),
                  onPressed: deletingOrder
                      ? null
                      : () async {
                          Logger logger = Logger();
                          logger.i("Deleting order...");

                          setState(() => deletingOrder = true);

                          try {
                            await FirestoreController.deleteDocument(
                              collection: "users/${order!.customerID}/orders",
                              id: order!.id,
                            );

                            logger.i("Order deleted successfully");
                            Fluttertoast.showToast(msg: "✅ Order deleted successfully!");
                            onRefresh?.call();
                            if (context.mounted) {
                              context.pop();
                              context.pop();
                            }
                          } on Exception catch (e, s) {
                            logger.e("Failed to delete order: ${e.toString()}");
                            logger.e(s);
                            Fluttertoast.showToast(msg: "❌ Failed to delete order, please try again later.");
                          } finally {
                            setState(() => deletingOrder = false);
                          }
                        },
                  child: deletingOrder ? Container(height: 20, width: 20, child: const Loader()) : const Text("Delete"),
                ),
              ],
            );
          });
        },
      );
}
