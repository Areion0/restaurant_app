import 'dart:async';

import 'package:flutter/material.dart';

import 'loader.dart';

/// A custom elevated button with a loading state and an optional icon suffix.
/// If the onPressed function returns a Future, the button will be disabled
/// and show a loading spinner until the Future is resolved.

class CustomElevatedButton extends StatefulWidget {
  final Widget child;
  final Icon? icon;
  final FutureOr<void> Function()? onPressed;

  final bool loading;

  final double height;
  final double width;

  const CustomElevatedButton({
    required this.child,
    this.icon,
    required this.onPressed,
    this.loading = false,
    this.height = 50,
    this.width = 200,
    super.key,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) => Container(
        height: widget.height,
        width: widget.width,
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () async {
                  if (widget.onPressed == null) return;

                  final result = widget.onPressed!();
                  if (result is Future) {
                    setState(() => loading = true);
                    await result;
                    setState(() => loading = false);
                  }
                },
          child: widget.loading || loading
              ? const Center(
                  child: Loader(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    widget.child,
                    if (widget.icon != null) widget.icon!,
                  ],
                ),
        ),
      );
}
