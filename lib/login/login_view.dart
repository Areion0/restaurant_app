import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../widgets/custom_elevated_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBlueprint(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Restaurant App", style: ThemeModel.theme.textTheme.headlineLarge),
            const Icon(
              Icons.restaurant_menu,
              size: 150,
              color: ThemeModel.darkBlue,
            ),
            Column(
              children: [
                Text(
                  "Welcome!",
                  style: ThemeModel.theme.textTheme.titleLarge,
                ),
                Text(
                  "Login to continue",
                  style: ThemeModel.theme.textTheme.titleMedium,
                ),
              ],
            ),
            Center(
              child: CustomElevatedButton(
                height: 65,
                width: context.mediaQuery.size.width * 0.4,
                onPressed: () async {
                  AuthController authController = context.read<AuthController>();

                  try {
                    await authController.signInWithGoogle();
                  } on Exception catch (e) {
                    Logger().e(e);
                    if (authController.userCredential?.user == null) {
                      Fluttertoast.showToast(msg: "❌ Login failed, please try again.");
                      // Logout google account
                      authController.signOut();
                      return;
                    }
                  }

                  Logger().i(authController.userCredential?.user!.displayName);
                  Logger().i(authController.userCredential?.user!.email);
                  Logger().i(authController.userCredential?.credential?.accessToken);

                  Fluttertoast.showToast(msg: "✅ Login successful!");

                  if (context.mounted) context.pushNamed("/home");
                },
                icon: const Icon(Icons.login),
                child: const Text("Login"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
