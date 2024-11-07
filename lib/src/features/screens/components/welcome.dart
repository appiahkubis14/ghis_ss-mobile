import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghis_ss/src/features/screens/components/home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, right: 10, bottom: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(80),
                ),
              ),
              child: Image.asset('assets/images/ghis_ss_logo.jpg',
                  width: double.infinity),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    80,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Let's connect \nwith each other",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Text(
                      overflow: TextOverflow.visible,
                      textDirection: TextDirection.ltr,
                      softWrap: true,
                      'The Ghana Institution of Surveyors (GhIS) was established on 28th February 1969 at the General Meeting of the Ghana Branch of the Royal Institute of Chartered Surveyors at which a resolution was passed to that effect and the Constitution was promulgated.',
                      style: TextStyle(
                          shadows: CupertinoContextMenu.kEndBoxShadow,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = !isLoading;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const HomeScreen();
                          },
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_sharp),
                    label: isLoading
                        ? const CupertinoActivityIndicator()
                        : const Text("Let's Get Started"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
