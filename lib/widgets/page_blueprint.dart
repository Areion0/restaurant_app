import 'package:flutter/material.dart';

class PageBlueprint extends StatefulWidget {
  final Widget child;
  const PageBlueprint({super.key, required this.child});

  @override
  State<PageBlueprint> createState() => _PageBlueprintState();
}

class _PageBlueprintState extends State<PageBlueprint> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 20),
        child: widget.child,
      ),
    );
  }
}
