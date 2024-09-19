import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/auth/auth_controller.dart';
import 'package:restaurant_app/misc/extensions.dart';

import '../widgets/loader.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  StreamSubscription<User?>? _authStateChanges;

  @override
  void initState() {
    super.initState();

    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      context.read<AuthController>().user = user;

      Logger logger = Logger();
      if (user == null) {
        logger.i("User is currently signed out!");

        context.pushNamedAndRemoveAll("/login");
      } else {
        logger.i("User is signed in!");

        context.pushNamedAndRemoveAll("/home");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _authStateChanges?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loader(),
      ),
    );
  }
}
