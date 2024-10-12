import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  StreamSubscription<User?>? _idTokenChanges;
  StreamSubscription<String>? _onFCMTokenRefresh;

  late HomeController homeController;

  bool firstTimeIdToken = true;

  @override
  void initState() {
    super.initState();

    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      Logger logger = Logger();
      if (user == null) {
        logger.i("User is currently signed out!");

        context.goToLogin();
      } else {
        logger.i(await user.getIdToken());
        context.authController.user ??= UserModel.fromMap(await FirestoreController.getDocument("users", user.uid));
        logger.i("User is signed in!");
      }
    });

    _idTokenChanges = FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      Logger logger = Logger();

      if (firstTimeIdToken) {
        firstTimeIdToken = false;
        return;
      }

      logger.i("Updated auth data");

      context.authController.firebaseUser = user;
    });
  }

  @override
  void dispose() {
    super.dispose();

    Logger().i("Disposing HomePage");

    _authStateChanges?.cancel();
    _idTokenChanges?.cancel();
    _onFCMTokenRefresh?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    homeController = context.watch<HomeController>();

    if (homeController.firstTime) {
      homeController.firstTime = false;

      homeController.prepareGalleries();
      requestNotificationsPermission();
    }
  }

  Future<void> requestNotificationsPermission() async {
    final notificationSettings = await FirebaseMessaging.instance.requestPermission();

    switch (notificationSettings.authorizationStatus) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        Logger().i("User granted permission to receive notifications!");
        await _handleFCMToken();
        break;
      case AuthorizationStatus.denied:
        Logger().i("User declined permission to receive notifications!");
        break;
      case AuthorizationStatus.notDetermined:
        Logger().i("User has not accepted or declined permission to receive notifications!");
        break;
    }
  }

  Future<void> _handleFCMToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      Logger().e("Failed to get FCM token!");
      return;
    }
    Logger().i("FCM token: $fcmToken");
    if (context.authController.user!.fcmToken.isEmpty || context.authController.user!.fcmToken != fcmToken) {
      await FirestoreController.saveFCMToken(fcmToken);
    }

    _onFCMTokenRefresh = FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      Logger().i("FCM token: $fcmToken");
      await FirestoreController.saveFCMToken(fcmToken);
    }, onError: (err) {
      Logger().e("Failed to listen to token refresh: $err");
    });
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
