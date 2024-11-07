import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode thememode = ThemeMode.light;
  bool get isDarkMode => thememode == ThemeMode.dark;
  void toggleTheeMode(bool isOn) {
    thememode = isOn ? ThemeMode.dark : ThemeMode.light;
  }
}
