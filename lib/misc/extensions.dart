import 'package:flutter/material.dart';

/// Extensions for [BuildContext]

extension ExtensionForBuildContext on BuildContext {
  /// Returns the [ThemeData] of the current [BuildContext].
  ThemeData get theme => Theme.of(this);

  /// Returns the [MediaQueryData] of the current [BuildContext].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [NavigatorState] of the current [BuildContext].
  NavigatorState get navigator => Navigator.of(this);

  /// Pops the current route
  void pop() => navigator.pop();

  /// Pushes the given route
  void push(Widget route) => navigator.push(
        MaterialPageRoute(builder: (_) => route),
      );

  /// Pushes the given route and removes all the previous routes
  void pushAndRemoveAll(Widget route) => navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => route),
        (route) => false,
      );
}
