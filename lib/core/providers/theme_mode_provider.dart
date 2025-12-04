import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skillseeds/core/providers/providers_state.dart' show prefsServiceProvider;

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;

  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = ref.read(prefsServiceProvider);
      final mode = prefs.getThemeMode();
      state = mode;
    } catch (e) {
      // keep system
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = ref.read(prefsServiceProvider);
      await prefs.setThemeMode(mode);
    } catch (e) {
      // ignore
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});
