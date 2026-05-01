import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted ThemeMode controller.
/// Default is [ThemeMode.light] until the user picks something else; switching
/// to System or Dark is a one-tap action in the drawer.
class ThemeController extends GetxController {
  static const _kKey = 'themeMode';

  final Rx<ThemeMode> mode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kKey);
    mode.value = _parse(stored);
  }

  Future<void> setMode(ThemeMode value) async {
    mode.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, _serialize(value));
  }

  /// Cycles system → light → dark → system.
  Future<void> cycle() async {
    switch (mode.value) {
      case ThemeMode.system:
        await setMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        await setMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setMode(ThemeMode.system);
        break;
    }
  }

  bool isDark(BuildContext context) {
    switch (mode.value) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  ThemeMode _parse(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String _serialize(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
