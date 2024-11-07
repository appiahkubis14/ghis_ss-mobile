import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/common/customIcons.dart';

class Bar extends StatefulWidget {
  const Bar({super.key});

  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        const Padding(
          padding: EdgeInsets.only(right: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/ghis_ss_logo.jpg'),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                ConstStrings.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: _toggleTheme,
        ),
        const CustomIons(),
        IconButton(
            onPressed: () {
              return FullScreenMenu.show(
                context,
                items: [
                  FSMenuItem(
                    icon: const Icon(Icons.ac_unit, color: Colors.white),
                    onTap: () {
                      Navigator.pop(context); // Close the full screen menu
                    },
                  ),
                  FSMenuItem(
                    icon: const Icon(Icons.wb_sunny, color: Colors.white),
                    text: const Text('Make hotter'),
                    onTap: () {
                      Navigator.pop(context); // Close the full screen menu
                    },
                  ),
                ],
              );
            },
            icon: const Icon(Icons.menu))
      ],
      elevation: 10,
    );
  }
}
