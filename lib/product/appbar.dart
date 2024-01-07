import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';
import 'package:restaurant_app/theme/theme_model.dart';

class ProductAppbar extends StatefulWidget {
  const ProductAppbar({super.key});

  @override
  State<ProductAppbar> createState() => _ProductAppbarState();
}

class _ProductAppbarState extends State<ProductAppbar> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Pasta Bolognese',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              setState(() {
                favorite = !favorite;
              });
            },
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: ThemeModel.darkRed,
            ),
          ),
        ),
      ],
    );
  }
}
