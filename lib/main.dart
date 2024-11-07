
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter/services.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/features/screens/components/welcome.dart';
>>>>>>> 15ac065 (updated)

void main(){
  runApp(const HomeScreen());
}

<<<<<<< HEAD
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
=======
class MyApp extends StatefulWidget {
  const MyApp({super.key});
>>>>>>> 15ac065 (updated)

  @override
  State<MyApp> createState() => _MyAppState();

  static of(BuildContext context) {}
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Container();
=======
    return MaterialApp(
      themeMode: _themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      onNavigationNotification: (notification) {
        return true;
      },
      color: const Color.fromARGB(255, 120, 111, 150),
      title: ConstStrings.mainTitle,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      themeAnimationDuration: Durations.extralong1,
      scrollBehavior: const ScrollBehavior(),
      actions: WidgetsApp.defaultActions,
      checkerboardOffscreenLayers: true,
    );
>>>>>>> 15ac065 (updated)
  }
}

