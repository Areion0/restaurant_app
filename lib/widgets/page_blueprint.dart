import 'package:flutter/material.dart';

import '../theme/theme_model.dart';
import 'loader.dart';

class PageBlueprint extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool fetching;
  const PageBlueprint({
    super.key,
    required this.child,
    this.padding,
    this.fetching = false,
  });

  @override
  State<PageBlueprint> createState() => _PageBlueprintState();
}

class _PageBlueprintState extends State<PageBlueprint> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 25),
          child: widget.fetching ? const Center(child: Loader(color: ThemeModel.darkBlue)) : widget.child),
    );
  }
}
