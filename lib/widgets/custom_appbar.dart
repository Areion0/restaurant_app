import 'package:flutter/material.dart';
import 'package:restaurant_app/misc/extensions.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    this.leading,
    this.title,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final Widget? leading;
  final Widget? title;
  final Icon icon;
  final Function onPressed;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const SizedBox(width: 20),
              leading ??
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, size: 35),
                  ),
            ],
          ),
          title ?? const SizedBox(),
          Row(
            children: [
              IconButton(
                onPressed: () => onPressed(),
                icon: icon,
              ),
              const SizedBox(width: 20),
            ],
          ),
        ]),
      ),
    );
  }
}
