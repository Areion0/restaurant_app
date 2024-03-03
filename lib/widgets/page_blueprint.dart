import 'package:flutter/material.dart';

class PageBlueprint extends StatefulWidget {
  final Widget child;
  final bool isHome;
  const PageBlueprint({
    super.key,
    required this.child,
    this.isHome = false,
  });

  @override
  State<PageBlueprint> createState() => _PageBlueprintState();
}

class _PageBlueprintState extends State<PageBlueprint> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: widget.child,
      ),
    );
  }
}
