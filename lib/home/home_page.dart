import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/home/home_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/models/user_model.dart';
import 'package:restaurant_app/widgets/custom_appbar.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../firebase/firestore_controller.dart';
import '../theme/theme_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<User?>? _authStateChanges;

  late HomeController homeController;

  @override
  void initState() {
    super.initState();

    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      Logger logger = Logger();
      if (user == null) {
        logger.i("User is currently signed out!");

        context.goToLogin();
      } else {
        context.authController.user ??= UserModel.fromMap(await FirestoreController.getDocument("users", user.uid));
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

    homeController = context.watch<HomeController>();

    if (homeController.firstTime) {
      homeController.firstTime = false;

      await homeController.prepareGalleries();
    }
  }

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
                    child: Selector<AuthController, String?>(
                        selector: (ctx, auth) => auth.user?.photoURL,
                        builder: (context, photoURL, child) => CircleAvatar(
                              backgroundImage: photoURL == null || photoURL.isEmpty
                                  ? null
                                  : NetworkImage(context.authController.user!.photoURL),
                            )),
                  ),
                  const SizedBox(width: 10),
                  Selector<AuthController, UserModel?>(
                    selector: (ctx, auth) => auth.user,
                    builder: (context, user, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName.split(" ").first ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.displayName.split(" ").last ?? "",
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
        icon: Selector<CartController, int>(
            selector: (ctx, cart) => cart.items.length,
            builder: (context, itemCount, child) {
              return Badge(
                isLabelVisible: itemCount > 0,
                label: Text(
                  itemCount.toString(),
                  style: ThemeModel.theme.textTheme.bodyMedium?.copyWith(
                    color: ThemeModel.lightGrey,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 35,
                ),
              );
            }),
        onIconPressed: () => context.pushNamed("/cart"),
      ),
      body: PageBlueprint(
        fetching: homeController.fetching,
        error: homeController.galleries.isEmpty,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: context.screenSize.height * 0.85,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 30),
                itemCount: homeController.galleries.length + (homeController.recentOrdersGallery != null ? 1 : 0),
                itemBuilder: (ctx, index) => ItemGallery(
                  gallery: homeController.recentOrdersGallery != null
                      ? index == 0
                          ? homeController.recentOrdersGallery!
                          : homeController.galleries[index - 1]
                      : homeController.galleries[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
