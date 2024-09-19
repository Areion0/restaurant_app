import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/firebase/firestore_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../models/product.dart';
import '../product/product_page.dart';
import '../theme/theme_model.dart';
import '../widgets/image_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<User?>? _authStateChanges;

  bool firstTime = true;
  bool fetching = false;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      Logger logger = Logger();
      if (user == null) {
        logger.i("User is currently signed out!");

        context.goToLogin();
      } else {
        context.authController.user = user;
        logger.i("User is signed in!");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    Logger().i("Disposing HomePage");

    _authStateChanges?.cancel();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (firstTime) {
      firstTime = false;

      Logger logger = Logger();
      try {
        setState(() => fetching = true);
        products = await FirestoreController.getProducts();
        items = await Future.wait(
          products.map(
            (product) async {
              return ImageButton(
                imageUrl: product.imageURL ?? "",
                onTap: () => context.push(
                  ProductPage(product: product),
                ),
              );
            },
          ),
        );
        setState(() {});
      } on Exception catch (e) {
        logger.e("Failed to get products: $e");
      } finally {
        setState(() => fetching = false);
      }
    }
  }

  List<String> titles = [
    "Recent Orders",
    "Most Popular",
    "Just Added",
    "Recommended",
  ];

  List<Widget> prefixes = const [
    Icon(
      Icons.shopping_bag_outlined,
      color: ThemeModel.darkBlue,
      size: 26,
    ),
    Text(
      "🔥",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "✨",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "👇",
      style: TextStyle(fontSize: 20),
    ),
  ];

  List<ImageButton> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => context.pushNamed("/profile"),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeModel.darkGrey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CircleAvatar(
                        backgroundImage: context.authController.user?.photoURL == null ||
                                context.authController.user!.photoURL!.isEmpty
                            ? null
                            : NetworkImage(context.authController.user!.photoURL!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Selector<AuthController, User?>(
                      selector: (ctx, auth) => auth.user,
                      builder: (context, user, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName?.split(" ")[0] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.displayName?.split(" ")[1] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 35,
          ),
          onIconPressed: () => context.pushNamed("/cart"),
        ),
        body: PageBlueprint(
          isHome: true,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: context.mediaQuery.size.height * 0.85,
                child: ItemGallery(
                  title: titles[0],
                  prefix: prefixes[0],
                  items: items,
                  fetching: fetching,
                ),
                // separatorBuilder: (context, index) => const SizedBox(height: 30),
                // ),
              ),
            ],
          ),
        ));
  }
}
