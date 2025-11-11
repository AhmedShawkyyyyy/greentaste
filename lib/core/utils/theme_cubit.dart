import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';
import 'shared_prefs_helper.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(SharedPrefsHelper.isDarkMode() ? ThemeMode.dark : ThemeMode.light));

  void toggleTheme() {
    final newThemeMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SharedPrefsHelper.setDarkMode(newThemeMode == ThemeMode.dark);
    emit(ThemeState(newThemeMode));
  }
}
