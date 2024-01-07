import 'dart:developer';

import 'package:flutter/material.dart';

import '../theme/theme_model.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // User Profile Image
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(50),
        //   child: Image.network(
        //     'https://example.com/image.jpg',
        //     width: 40,
        //     height: 40,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                log('Profile Image Tapped');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeModel.darkGrey,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: ThemeModel.darkBlue,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Name & Surname
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Doe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Cart Icon
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 34,
          ),
          onPressed: () {
            log('Cart Tapped');
          },
        ),
      ],
    );
  }
}
