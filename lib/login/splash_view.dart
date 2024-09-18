import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (isUserLoggedIn) {
        context.pushNamedAndRemoveAll("/home");
      } else {
        context.pushNamedAndRemoveAll("/login");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}