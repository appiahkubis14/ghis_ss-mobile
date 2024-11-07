// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/common/customField.dart';
import 'package:ghis_ss/src/features/screens/auth_screens/index.dart';
import 'package:ghis_ss/src/features/screens/components/forgotpassword.dart';
import 'package:ghis_ss/src/mapping/map.dart';
import 'package:ghis_ss/src/features/screens/components/pin_reset.dart';
import 'package:ghis_ss/src/features/screens/components/settings.dart';
import 'package:ghis_ss/src/features/screens/components/updateprofile.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key});

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, don't unfocus
      }
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.asset(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 40,
                        'assets/images/welcome.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  CustomTextField(
                    maxlenght: 8,
                    inputType: TextInputType.number,
                    controller: _codeController,
                    labelText: 'Pin',
                    icon: Icons.nature_people_sharp,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: _obscured,
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: _toggleObscured,
                            child: Icon(
                              _obscured
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                        fillColor: Colors.grey,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Haven't registered ?"),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegistrtionForm(),
                                ),
                              );
                            },
                            child: const Text(
                              'register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 7, 11, 255),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 50),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot password ?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 7, 11, 255),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 60,
                    child: FloatingActionButton(
                      backgroundColor: Colors.blueAccent,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          _login();
                        }
                      },
                      child: isLoading
                          ? const CupertinoActivityIndicator()
                          : const Center(
                              child: Text(
                                'LOGIN',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String code = _codeController.text;
    final String password = _passwordController.text;

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ghis-ss-members')
          .where('EMAIL', isEqualTo: email)
          .where('UNIQUE CODE', isEqualTo: code)
          .where('PASSWORD', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Save user login state locally
        // For example, using shared preferences
        // This is just a demonstration, you may need to adjust it according to your requirement
        // Save user information or token in shared preferences or local storage
        // For example:
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('userToken', userToken);

        // Navigate to notification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(
              userData: querySnapshot.docs.first.data() as Map<String, dynamic>,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred, please try again'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}

class NotificationScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const NotificationScreen({super.key, this.userData});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String _MessageHeading = '';
  String _messageBody = '';
  String _tokenid = '';

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      _tokenid = token!;
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        setState(
          () {
            _MessageHeading = message.notification!.title ?? '';
            _messageBody = message.notification!.body ?? '';
          },
        );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        setState(
          () {
            _MessageHeading = message.notification!.title ?? '';
            _messageBody = message.notification!.body ?? '';
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 153, 184),
        title: const Text('NEWS'),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Greetings , ${widget.userData!['FIRST NAME']}'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  child: CircleAvatar(
                    backgroundImage: widget.userData!['IMAGE URL'] == null
                        ? Image.asset('assets/images/ghis_ss_logo.jpg')
                            as ImageProvider<Object>?
                        : NetworkImage(
                            widget.userData!['IMAGE URL'],
                          ),
                  ),
                  onTap: () {
                    AlertDialog(
                      content: CircleAvatar(
                        backgroundImage: widget.userData!['IMAGE URL'] == null
                            ? Image.asset('assets/images/ghis_ss_logo.jpg')
                                as ImageProvider<Object>?
                            : NetworkImage(
                                widget.userData!['IMAGE URL'],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Message Heading: $_MessageHeading',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Message Body: $_messageBody',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Token: $_tokenid',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
