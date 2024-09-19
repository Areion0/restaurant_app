import 'dart:convert';

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

  /// Pops until the given route
  void popUntil(String routeName) => navigator.popUntil((route) => route.settings.name == routeName);
  void goHome() => popUntil("/home");

  /// Pushes the given Widget
  void push(Widget route, {String? name}) => navigator.push(animatedPageRoute(route, name: name));

  /// Pushes the route with the given name
  void pushNamed(String routeName) => navigator.pushNamed(routeName);

  /// Pushes the given Widget and removes all the previous routes
  void pushAndRemoveAll(Widget route, {String? name}) => navigator.pushAndRemoveUntil(
        animatedPageRoute(route, name: name),
        (route) => false,
      );

  /// Pushes the route with the given name and removes all the previous routes
  void pushNamedAndRemoveAll(String routeName) => navigator.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
      );
}

// Wrapper to animate routes
PageRouteBuilder animatedPageRoute(Widget route, {String? name}) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      settings: RouteSettings(name: name),
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

/// Wrapper to animate named routes
RouteFactory animatedRouter(Map<String, Widget> routes) =>
    (settings) => animatedPageRoute(routes[settings.name]!, name: settings.name);

/// Extensions for [Map]

extension ExtensionForMap on Map {
  /// Returns the pretty formatted JSON string of the [Map].
  String get pretty => const JsonEncoder.withIndent('  ').convert(this);
}
