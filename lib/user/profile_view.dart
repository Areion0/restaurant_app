import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/widgets/custom_elevated_button.dart';
import 'package:restaurant_app/widgets/page_blueprint.dart';

import '../theme/theme_model.dart';
import '../widgets/custom_appbar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Selector<AuthController, String?>(
          selector: (context, authController) => authController.user?.displayName,
          builder: (context, displayName, child) => Text(
            displayName ?? "Profile",
            style: ThemeModel.theme.textTheme.titleMedium,
          ),
        ),
      ),
      body: PageBlueprint(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Profile Picture
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<AuthController, String?>(
                selector: (context, authController) => authController.user?.photoURL,
                builder: (context, photoURL, child) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeModel.darkGrey,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    foregroundImage: photoURL == null || photoURL.isEmpty ? null : NetworkImage(photoURL),
                    child: photoURL == null || photoURL.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 80,
                          )
                        : null,
                  ),
                ),
              ),
              const Gap(10),
              Selector<AuthController, String?>(
                selector: (context, authController) => authController.user?.email,
                builder: (context, email, child) => Text(
                  email ?? "Email",
                  style: ThemeModel.theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),

          // My orders Button
          CustomElevatedButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              context.pushNamed("/my_orders");
            },
            child: Text(context.authController.user?.isAdmin ?? false ? "Orders" : "My Orders"),
          ),

          // Log Out Button
          CustomElevatedButton(
            icon: const Icon(Icons.logout),
            onPressed: context.authController.signOut,
            child: const Text("Log Out"),
          ),
        ],
      ))),
    );
  }
}
