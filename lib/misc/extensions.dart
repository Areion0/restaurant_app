import 'package:flutter/material.dart';

/// Extensions for [BuildContext]

extension ExtensionForBuildContext on BuildContext {
  /// Returns the [ThemeData] of the current [BuildContext].
  ThemeData get theme => Theme.of(this);

  /// Returns the [MediaQueryData] of the current [BuildContext].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  /// Returns the [NavigatorState] of the current [BuildContext].
  NavigatorState get navigator => Navigator.of(this);

  /// Pops the current route
  void pop() => navigator.pop();

  /// Pushes the given route
  void push(Widget route) => navigator.push(animatedPageRoute(route));

  /// Pushes the given route and removes all the previous routes
  void pushAndRemoveAll(Widget route) => navigator.pushAndRemoveUntil(
        animatedPageRoute(route),
        (route) => false,
      );
}

// Animated Page Route function
PageRouteBuilder animatedPageRoute(Widget route) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionDuration: const Duration(milliseconds: 150),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1, 0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
