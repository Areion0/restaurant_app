import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/loader.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool authenticating = false;

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
              child: Container(
                height: 65,
                width: context.mediaQuery.size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => authenticating = true);

                    UserCredential? user;

                    try {
                      user = await signInWithGoogle();
                    } on Exception catch (e) {
                      Logger().e(e);
                      if (user?.user == null) {
                        Fluttertoast.showToast(msg: "❌ Login failed, please try again.");
                        return;
                      }
                    } finally {
                      setState(() => authenticating = false);
                    }

                    Logger().i(user?.user!.displayName);
                    Logger().i(user?.user!.email);
                    Logger().i(user?.credential?.accessToken);

                    Fluttertoast.showToast(msg: "✅ Login successful!");

                    if (context.mounted) context.pushNamed("/home");
                  },
                  child: authenticating
                      ? const Center(
                          child: Loader(
                          color: ThemeModel.lightGrey,
                        ))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Login",
                            ),
                            Icon(
                              Icons.login,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
