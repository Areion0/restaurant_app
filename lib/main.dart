import 'package:flutter/material.dart';
import 'package:restaurant_app/home/home.dart';
import 'package:restaurant_app/theme/theme_model.dart';

void main() {
  runApp(
     const RestaurantApp(),
  );
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeModel.theme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
