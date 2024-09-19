import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/home/home_page.dart';
import 'package:restaurant_app/login/login_view.dart';
import 'package:restaurant_app/theme/theme_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login/splash_view.dart';
import 'misc/extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => CartController()),
    ], child: const RestaurantApp()),
  );
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      theme: ThemeModel.theme,
      initialRoute: "/splash",
      onGenerateInitialRoutes: (initialRoute) => [animatedPageRoute(const SplashView())],
      onGenerateRoute: animatedRouter({
        "/splash": const SplashView(),
        "/login": const LoginView(),
        "/home": const HomePage(),
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
