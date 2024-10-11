import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/cart/cart_controller.dart';
import 'package:restaurant_app/home/home_controller.dart';

import '../auth/auth_controller.dart';

extension BuildContextExtensions on BuildContext {
  /// Returns the [ThemeData] of the current [BuildContext].
  ThemeData get theme => Theme.of(this);

  /// Returns the [Size] of the current Screen.
  Size get screenSize => MediaQuery.sizeOf(this);

  double get height => screenSize.height;
  double get width => screenSize.width;

  /// Returns the [NavigatorState] of the current [BuildContext].
  NavigatorState get navigator => Navigator.of(this);

  /// Pops the current route
  void pop() => navigator.pop();

  /// Pops until the given route
  void popUntil(String routeName) => navigator.popUntil((route) => route.settings.name == routeName);
  void popToHome() => popUntil("/home");

  /// Pushes the given Widget
  void push(Widget route, {String? name, Object? arguments}) =>
      navigator.push(animatedPageRoute(route, name: name, arguments: arguments));

  /// Pushes the route with the given name
  void pushNamed(String routeName, {Object? arguments}) => navigator.pushNamed(routeName, arguments: arguments);

  /// Pushes the given Widget and removes all the previous routes
  void pushAndRemoveAll(Widget route, {String? name, Object? arguments}) => navigator.pushAndRemoveUntil(
        animatedPageRoute(route, name: name, arguments: arguments),
        (route) => false,
      );

  /// Pushes the route with the given name and removes all the previous routes
  void pushNamedAndRemoveAll(String routeName, {Object? arguments}) => navigator.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );
  void goToLogin() => pushNamedAndRemoveAll("/login");

  /// Provider shortcuts for easy access
  HomeController get homeController => read<HomeController>();
  AuthController get authController => read<AuthController>();
  CartController get cartController => read<CartController>();
}

// Wrapper to animate routes
PageRouteBuilder animatedPageRoute(Widget route, {String? name, Object? arguments}) => PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      settings: RouteSettings(name: name, arguments: arguments),
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
    (settings) => animatedPageRoute(routes[settings.name]!, name: settings.name, arguments: settings.arguments);

extension MapExtensions on Map {
  /// Returns the pretty formatted JSON string of the [Map].
  String get pretty => const JsonEncoder.withIndent('  ').convert(this);
}

extension DateTimeExtensions on DateTime {
  /// Returns the formatted date string.
  String get formattedDate => "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";

  /// Returns the formatted time string.
  String get formattedTime => "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

  /// Returns the formatted date and time string.
  String get formattedDateTime => "$formattedDate $formattedTime";
}

extension IconExtensions on Icon {
  /// Returns the [Icon] with the given [color].
  Icon withColor(Color color) => Icon(icon, size: size, color: color);

  /// Returns the [Icon] with the given [size].
  Icon withSize(double size) => Icon(icon, color: color, size: size);
}
