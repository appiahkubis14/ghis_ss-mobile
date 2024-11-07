// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';

class ImageUrl {
  static const imageUrl =
      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png';
  static const logo = '';
}

class colorstheme {
  static const backgroundColor = Colors.black;
  static Color? buttonColor = const Color.fromARGB(255, 202, 192, 192);
  static const borderColor = Colors.grey;
  static const customRColor = Color.fromARGB(255, 32, 211, 234);
  static const customLColor = Color.fromARGB(255, 250, 45, 108);
  static ThemeData darkmode = ThemeData(brightness: Brightness.dark);
  static ThemeData lightmode = ThemeData(brightness: Brightness.light);
}

class ConstStrings {
  static const mainTitle = 'GhIS-SS REGISTRATION MOBILE APP';
  static const notify =
      'These detailed credential from you is to help Ghana Institution of Surveyors Student Society(GhiS_SS) improve and secure their members in the society.';
  static const warn = 'NOTE THIS CAREFULLY';
  static const passon = 'GhIS-SS NEEDS AUTHENTIC INFORMATION';
  static const title = 'GhIS-SS';
  static Image logo = Image.asset('assets/images/ghis_ss_logo.jpg');
}
