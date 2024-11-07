// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_element, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/common/customField.dart';
import 'package:ghis_ss/src/features/screens/components/forgotpassword.dart';
import 'package:ghis_ss/src/mapping/map.dart';
import 'package:ghis_ss/src/features/screens/components/pin_reset.dart';
import 'package:ghis_ss/src/features/screens/components/settings.dart';
import 'package:image_picker/image_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool IsLoading = false;

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
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
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.asset(
                        // height: 180,
                        // width: 200,
                        'assets/images/img1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    inputType: TextInputType.number,
                    maxlenght: 10,
                    isObscured: false,
                    controller: _codeController,
                    labelText: 'Pin',
                    icon: Icons.nature_people_sharp,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.none,
                      undoController: UndoHistoryController(),
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
                  Container(
                    padding: const EdgeInsets.only(
                      left: 200,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const ForgotPasswordScreen();
                          },
                        ));
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            IsLoading = !IsLoading;
                          });
                          _login();
                        }
                      },
                      child: IsLoading
                          ? const CircularProgressIndicator()
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

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(
          icon,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String code = _codeController.text;
    final String password = _passwordController.text;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ghis-ss-members')
          .where('EMAIL', isEqualTo: email)
          .where('UNIQUE CODE', isEqualTo: code)
          .where('PASSWORD', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              userData: userData,
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
        IsLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred, please try again'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      IsLoading = false;
    });
  }
}

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserProfilePage({super.key, this.userData});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _middlenameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  late TextEditingController _passwordController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _levelController;
  late TextEditingController _programController;
  late TextEditingController _foliooController;
  late TextEditingController _visionController;
  File? _imageFile;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userData!['FIRST NAME']);
    _middlenameController =
        TextEditingController(text: widget.userData!['MIDDLE NAME']);
    _surnameController =
        TextEditingController(text: widget.userData!['SURNAME']);
    _emailController = TextEditingController(text: widget.userData!['EMAIL']);
    _dobController = TextEditingController(text: widget.userData!['DOB']);
    _studentIdController =
        TextEditingController(text: widget.userData!['STUDENT ID']);
    _passwordController =
        TextEditingController(text: widget.userData!['PASSWORD']);
    _phoneController =
        TextEditingController(text: widget.userData!['PHONE NUMBER']);
    _levelController =
        TextEditingController(text: widget.userData!['LEVEL/YEAR']);
    _programController =
        TextEditingController(text: widget.userData!['PROGRAM STUDY']);
    _foliooController =
        TextEditingController(text: widget.userData!['POTFOLIO']);
    _visionController =
        TextEditingController(text: widget.userData!['MEMBER EXPECTATION']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _middlenameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _surnameController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _levelController.dispose();
    _programController.dispose();
    _foliooController.dispose();
    _visionController.dispose();
    super.dispose();
  }

  Future<void> _updateUserData() async {
    try {
      var collection = FirebaseFirestore.instance.collection('ghis-ss-members');
      var querySnapshots = await collection.get();
      for (var doc in querySnapshots.docs) {
        for (var value in doc.data().values) {
          if (value == widget.userData!['UNIQUE CODE']) {
            print(value);
            print(widget.userData!['UNIQUE CODE']);
            await doc.reference.update({
              'FIRST NAME': '${_nameController.text}',
              'SURNAME': '${_surnameController.text}',
              'EMAIL': '${_emailController.text}',
              'MIDDLE NAME': '${_middlenameController.text}',
              'DOB': '${_dobController.text}',
              'PASSWORD': '${_passwordController.text}',
              'PHONE NUMBER': '${_phoneController.text}',
              'STUDENT ID': '${_studentIdController.text}',
              'LEVEL/YEAR': '${_levelController.text}',
              'PROGRAM STUDY': '${_programController.text}',
              'POTFOLIO': '${_foliooController.text}',
              'MEMBER EXPECTATION': '${_visionController.text}',
            });
          }
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('User data updated successfully'),
          );
        },
      );
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('An error occurred, please try again: $error'),
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USER PROFILE'),
        actions: [
          IconButton(
            icon: _isEditing ? const Icon(Icons.done) : const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider<Object>
                            : NetworkImage(
                                widget.userData!['IMAGE URL'],
                              ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 130,
                        child: IconButton(
                          onPressed: () {
                            if (_isEditing) {
                              _showImageSelectionDialog();
                            }
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                    controller: _nameController,
                    labeltext: 'First name',
                    icon: Icons.supervised_user_circle_outlined,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _middlenameController,
                    labeltext: 'Middle name',
                    icon: Icons.person_add_alt,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _surnameController,
                    labeltext: 'Surname',
                    icon: Icons.person_2_sharp,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _emailController,
                    labeltext: 'Email',
                    icon: Icons.email,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _studentIdController,
                    labeltext: 'Student ID',
                    icon: Icons.school,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _passwordController,
                    labeltext: 'Password',
                    icon: Icons.lock,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _dobController,
                    labeltext: 'DOB',
                    icon: Icons.calendar_month,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _phoneController,
                    labeltext: 'Phone number',
                    icon: Icons.phone,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _levelController,
                    labeltext: 'Level',
                    icon: Icons.ads_click_outlined,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _programController,
                    labeltext: 'Programme',
                    icon: Icons.pix_rounded,
                    isediting: _isEditing),
                CustomFormField(
                    controller: _foliooController,
                    labeltext: 'Potfolio',
                    icon: Icons.portrait_outlined,
                    isediting: _isEditing),
                CustomFormField(
                    lines: 10,
                    controller: _visionController,
                    labeltext: 'Expectation',
                    icon: Icons.generating_tokens_rounded,
                    isediting: _isEditing),
                const SizedBox(height: 20),
                if (_isEditing)
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    height: 90,
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _updateUserData();
                      },
                      label: _isLoading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                              animating: true,
                              radius: 20,
                            ))
                          : SizedBox(
                              height: 60,
                              width: MediaQuery.of(context).size.width - 40,
                              child: const Center(
                                child: Text(
                                  'UPDATE NOW',
                                ),
                              ),
                            ),
                      icon: const Icon(Icons.update),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      extendBodyBehindAppBar: true,
    );
  }

  Future<void> _showImageSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('SELECT PROFILE')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _selectImageFromGallery();
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.photo),
                      SizedBox(width: 10),
                      Text('FROM GALLERY'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _takePicture();
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.camera_alt),
                      SizedBox(width: 10),
                      Text('FORM CAMERA'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isediting;
  final String labeltext;
  final IconData icon;
  final int? lines;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.isediting,
    required this.labeltext,
    required this.icon,
    this.lines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        maxLines: lines,
        controller: controller,
        enabled: isediting,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labeltext,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

  // Widget _buildTextField(
  //     TextEditingController controller, String labelText, bool isEditing) {
  //   return TextFormField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       labelText: labelText,
  //       enabled: isEditing,
  //     ),
  //     readOnly: !isEditing,
  //   );
  // }

// ignore: duplicate_ignore
// ignore_for_file: library_private_types_in_public_api, unnecessary_string_interpolations, use_build_context_synchronously

// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ghis_ss/src/features/screens/home/forgotpassword.dart';
// import 'package:image_picker/image_picker.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _obscured = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Center(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       icon: Icon(Icons.mark_email_read_rounded),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Email is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _codeController,
//                     decoration: const InputDecoration(
//                       labelText: 'Pin',
//                       icon: Icon(Icons.nature_people_sharp),
//                     ),
//                     keyboardType: TextInputType.number,
//                     maxLength: 10,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Pin is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscured,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       icon: const Icon(Icons.lock),
//                       suffixIcon: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _obscured = !_obscured;
//                           });
//                         },
//                         child: Icon(
//                           _obscured
//                               ? Icons.visibility_rounded
//                               : Icons.visibility_off_rounded,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Password is required';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ForgotPasswordScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Forgot password ?',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.amber,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 40,
//                     height: 60,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isLoading = true;
//                           });
//                           _login();
//                         }
//                       },
//                       child: _isLoading
//                           ? const CircularProgressIndicator()
//                           : const Center(
//                               child: Text('LOGIN'),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _login() async {
//     final String email = _emailController.text;
//     final String code = _codeController.text;
//     final String password = _passwordController.text;

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('ghis-ss-members')
//           .where('EMAIL', isEqualTo: email)
//           .where('UNIQUE CODE', isEqualTo: code)
//           .where('PASSWORD', isEqualTo: password)
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         Map<String, dynamic> userData =
//             querySnapshot.docs.first.data() as Map<String, dynamic>;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UserProfilePage(userData: userData),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Invalid credentials'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred, please try again'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

// class UserProfilePage extends StatefulWidget {
//   final Map<String, dynamic>? userData;

//   const UserProfilePage({super.key, this.userData});

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   late TextEditingController _nameController;
//   late TextEditingController _middlenameController;
//   late TextEditingController _surnameController;
//   late TextEditingController _emailController;
//   late TextEditingController _studentIdController;
//   late TextEditingController _passwordController;
//   late TextEditingController _dobController;
//   late TextEditingController _phoneController;
//   late TextEditingController _levelController;
//   late TextEditingController _programController;
//   late TextEditingController _foliooController;
//   late TextEditingController _visionController;
//   File? _imageFile;
//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController =
//         TextEditingController(text: widget.userData!['FIRST NAME']);
//     _middlenameController =
//         TextEditingController(text: widget.userData!['MIDDLE NAME']);
//     _surnameController =
//         TextEditingController(text: widget.userData!['SURNAME']);
//     _emailController = TextEditingController(text: widget.userData!['EMAIL']);
//     _dobController = TextEditingController(text: widget.userData!['DOB']);
//     _studentIdController =
//         TextEditingController(text: widget.userData!['STUDENT ID']);
//     _passwordController =
//         TextEditingController(text: widget.userData!['PASSWORD']);
//     _phoneController =
//         TextEditingController(text: widget.userData!['PHONE NUMBER']);
//     _levelController =
//         TextEditingController(text: widget.userData!['LEVEL/YEAR']);
//     _programController =
//         TextEditingController(text: widget.userData!['PROGRAM STUDY']);
//     _foliooController =
//         TextEditingController(text: widget.userData!['POTFOLIO']);
//     _visionController =
//         TextEditingController(text: widget.userData!['MEMBER EXPECTATION']);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _middlenameController.dispose();
//     _emailController.dispose();
//     _studentIdController.dispose();
//     _surnameController.dispose();
//     _passwordController.dispose();
//     _dobController.dispose();
//     _phoneController.dispose();
//     _levelController.dispose();
//     _programController.dispose();
//     _foliooController.dispose();
//     _visionController.dispose();
//     super.dispose();
//   }

//   Future<void> _updateUserData() async {
//     try {
//       var collection = FirebaseFirestore.instance.collection('ghis-ss-members');
//       var querySnapshots = await collection.get();
//       for (var doc in querySnapshots.docs) {
//         for (var value in doc.data().values) {
//           if (value == widget.userData!['UNIQUE CODE']) {
//             await doc.reference.update({
//               'FIRST NAME': '${_nameController.text}',
//               'SURNAME': '${_surnameController.text}',
//               'EMAIL': '${_emailController.text}',
//               'MIDDLE NAME': '${_middlenameController.text}',
//               'DOB': '${_dobController.text}',
//               'PASSWORD': '${_passwordController.text}',
//               'PHONE NUMBER': '${_phoneController.text}',
//               'STUDENT ID': '${_studentIdController.text}',
//               'LEVEL/YEAR': '${_levelController.text}',
//               'PROGRAM STUDY': '${_programController.text}',
//               'POTFOLIO': '${_foliooController.text}',
//               'MEMBER EXPECTATION': '${_visionController.text}',
//             });
//           }
//         }
//       }
//       showDialog(
//         context: context,
//         builder: (context) {
//           return const AlertDialog(
//             content: Text('User data updated successfully'),
//           );
//         },
//       );
//     } catch (error) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('An error occurred, please try again: $error'),
//           );
//         },
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _selectImageFromGallery() async {
//     final imagePicker = ImagePicker();
//     final pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   Future<void> _takePicture() async {
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('USER PROFILE'),
//         actions: [
//           IconButton(
//             icon: _isEditing ? const Icon(Icons.done) : const Icon(Icons.edit),
//             onPressed: () {
//               setState(() {
//                 _isEditing = !_isEditing;
//               });
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Stack(
//                   children: <Widget>[
//                     CircleAvatar(
//                       radius: 90,
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!) as ImageProvider<Object>
//                           : NetworkImage(widget.userData!['IMAGE URL']),
//                     ),
//                     Positioned(
//                       bottom: -10,
//                       left: 130,
//                       child: IconButton(
//                         onPressed: () {
//                           if (_isEditing) {
//                             _showImageSelectionDialog();
//                           }
//                         },
//                         icon: const Icon(Icons.add_a_photo),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomFormField(
//                 controller: _nameController,
//                 labelText: 'First name',
//                 icon: Icons.supervised_user_circle_outlined,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _middlenameController,
//                 labelText: 'Middle name',
//                 icon: Icons.person_add_alt,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _surnameController,
//                 labelText: 'Surname',
//                 icon: Icons.person_2_sharp,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _emailController,
//                 labelText: 'Email',
//                 icon: Icons.email,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _studentIdController,
//                 labelText: 'Student ID',
//                 icon: Icons.school,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _passwordController,
//                 labelText: 'Password',
//                 icon: Icons.lock,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _dobController,
//                 labelText: 'DOB',
//                 icon: Icons.calendar_month,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _phoneController,
//                 labelText: 'Phone number',
//                 icon: Icons.phone,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _levelController,
//                 labelText: 'Level',
//                 icon: Icons.ads_click_outlined,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _programController,
//                 labelText: 'Programme',
//                 icon: Icons.pix_rounded,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 controller: _foliooController,
//                 labelText: 'Potfolio',
//                 icon: Icons.portrait_outlined,
//                 isEditing: _isEditing,
//               ),
//               CustomFormField(
//                 lines: 10,
//                 controller: _visionController,
//                 labelText: 'Expectation',
//                 icon: Icons.generating_tokens_rounded,
//                 isEditing: _isEditing,
//               ),
//               const SizedBox(height: 20),
//               if (_isEditing)
//                 Container(
//                   padding: const EdgeInsets.only(top: 30),
//                   height: 90,
//                   width: MediaQuery.of(context).size.width - 40,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                       });
//                       _updateUserData();
//                     },
//                     label: _isLoading
//                         ? const CupertinoActivityIndicator.partiallyRevealed()
//                         : SizedBox(
//                             height: 60,
//                             width: MediaQuery.of(context).size.width - 40,
//                             child: const Center(
//                               child: Text('UPDATE NOW'),
//                             ),
//                           ),
//                     icon: const Icon(Icons.update),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _showImageSelectionDialog() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Center(child: Text('SELECT PROFILE')),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () {
//                     _selectImageFromGallery();
//                     Navigator.of(context).pop();
//                   },
//                   child: const Row(
//                     children: <Widget>[
//                       Icon(Icons.photo),
//                       SizedBox(width: 10),
//                       Text('FROM GALLERY'),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     _takePicture();
//                     Navigator.of(context).pop();
//                   },
//                   child: const Row(
//                     children: <Widget>[
//                       Icon(Icons.camera_alt),
//                       SizedBox(width: 10),
//                       Text('FROM CAMERA'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class CustomFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool isEditing;
//   final String labelText;
//   final IconData icon;
//   final int? lines;

//   const CustomFormField({
//     Key? key,
//     required this.controller,
//     required this.isEditing,
//     required this.labelText,
//     required this.icon,
//     this.lines,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width - 40,
//       padding: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextFormField(
//         maxLines: lines,
//         controller: controller,
//         enabled: isEditing,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: labelText,
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
