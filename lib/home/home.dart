import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/item_gallery.dart';

import '../theme/theme_model.dart';
import '../widgets/home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  List<String> titles = [
    "Last Order",
    "Most Popular",
    "Just Added",
    "Recommended",
  ];

  List<Widget> prefixes = const [
    Icon(
      Icons.shopping_bag_outlined,
      color: ThemeModel.darkBlue,
      size: 26,
    ),
    Text(
      "🔥",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "✨",
      style: TextStyle(fontSize: 20),
    ),
    Text(
      "👇",
      style: TextStyle(fontSize: 20),
    ),
  ];

  List<List<String>> items = [
    [""],
    ["", "", "", ""],
    ["", "", "", ""],
    ["", "", "", ""],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: HomeAppbar(),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 800,
                  child: ListView.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: index == 0 ? 30 : 0),
                      child: ItemGallery(
                        title: titles[index],
                        prefix: prefixes[index],
                        items: items[index],
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
