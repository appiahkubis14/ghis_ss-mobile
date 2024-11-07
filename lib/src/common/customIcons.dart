import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghis_ss/src/mapping/map.dart';
import 'package:ghis_ss/src/features/screens/components/pin_reset.dart';
import 'package:ghis_ss/src/features/screens/components/settings.dart';
import 'package:ghis_ss/src/features/screens/components/updateprofile.dart';

class CustomIons extends StatefulWidget {
  const CustomIons({super.key});

  @override
  State<CustomIons> createState() => _CustomIonsState();
}

class _CustomIonsState extends State<CustomIons> {
  final GeolocatorPlatform _geoPlatform = GeolocatorPlatform.instance;

  void _locationSettings() async {
    await _geoPlatform.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          useRootNavigator: true,
          barrierDismissible: true,
          useSafeArea: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              actionsAlignment: MainAxisAlignment.center,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const GoogleMapScreen();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 156, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.location_on),
                              ),
                              const SizedBox(height: 10),
                              const Text('Map'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 247, 7, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(height: 10),
                              const Text('Status'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const SettingsScreen();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 15, 255, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.settings),
                              ),
                              const SizedBox(height: 10),
                              const Text('Settings'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const PinReset();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 7, 156, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.pin),
                              ),
                              const SizedBox(height: 10),
                              const Text('Pin-Reset'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            return _locationSettings();
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 7, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.location_disabled),
                              ),
                              const SizedBox(height: 10),
                              const Text('Location'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return exit(0);
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 7, 131),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.logout),
                              ),
                              const SizedBox(height: 10),
                              const Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const PinReset();
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 85, 7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.format_align_center),
                              ),
                              const SizedBox(height: 10),
                              const Text('Form'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            return _locationSettings();
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 170, 153, 182),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Badge(
                                  isLabelVisible: true,
                                  child: Icon(Icons.message),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Messages'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return exit(0);
                              },
                            ));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 7, 247, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: const Icon(Icons.privacy_tip),
                              ),
                              const SizedBox(height: 10),
                              const Text('Privacy'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(
        Icons.add_link_sharp,
      ),
    );
  }
}
