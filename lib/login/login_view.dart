import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

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
              child: Container(
                height: 65,
                width: context.mediaQuery.size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () => context.pushNamed("/home"),
                  child: const Row(
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

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
