import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/common/customIcons.dart';
import 'package:ghis_ss/src/features/screens/auth_screens/index.dart';
import 'package:ghis_ss/src/news/news_page.dart';
import 'package:ghis_ss/src/features/screens/components/updateprofile.dart';
import 'package:ghis_ss/src/features/screens/components/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: PageView(
        pageSnapping: true,
        onPageChanged: (value) {
          setState(() {
            activeIndex = value;
          });
        },
        controller: _pageController,
        children: const [
          NewsPage(),
          RegistrtionForm(),
          NotifyScreen(),
          LoginPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 25,
        useLegacyColorScheme: true,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 7, 65, 255),
        currentIndex: activeIndex,
        iconSize: 25,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 100), curve: Curves.ease);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.data_saver_on,
            ),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              padding: EdgeInsets.all(10),
              largeSize: 2,
              isLabelVisible: true,
              child: Icon(
                Icons.notifications_active,
              ),
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Status',
          ),
        ],
      ),
    );
  }
}
