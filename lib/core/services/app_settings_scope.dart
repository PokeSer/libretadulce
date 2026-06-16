import 'package:flutter/material.dart';
import 'app_settings.dart';

/// Provides [AppSettings] down the widget tree via [InheritedNotifier].
///
/// Usage:
/// ```dart
/// final settings = AppSettingsScope.of(context);
/// ```
class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'No AppSettingsScope found in widget tree');
    return scope!.notifier!;
  }
}
