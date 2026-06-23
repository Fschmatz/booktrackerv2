import 'package:flutter/material.dart';

class ToastUtils {
  ToastUtils._();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(String message, {Duration duration = const Duration(seconds: 3)}) {
    scaffoldMessengerKey.currentState?.let((messenger) {
      final colorScheme = Theme.of(messenger.context).colorScheme;
      _display(messenger, colorScheme, message, duration: duration);
    });
  }

  static void _display(ScaffoldMessengerState messenger, ColorScheme colorScheme, String message, {Duration duration = const Duration(seconds: 3)}) {
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: colorScheme.inverseSurface,
          content: Text(message, style: TextStyle(color: colorScheme.onInverseSurface)),
          duration: duration,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

extension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
