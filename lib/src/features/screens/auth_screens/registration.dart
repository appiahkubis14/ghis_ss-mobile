// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, non_constant_identifier_names, unused_local_variable, unused_element, depend_on_referenced_packages, must_be_immutable, unrelated_type_equality_checks, collection_methods_unrelated_type, unnecessary_string_interpolations, avoid_unnecessary_containers
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghis_ss/src/common/customIcons.dart';
import 'package:ghis_ss/src/common/utils.dart';
import 'package:ghis_ss/src/common/constant.dart';
import 'package:ghis_ss/src/common/customField.dart';
import 'package:ghis_ss/src/common/selectForm.dart';
import 'package:ghis_ss/src/features/screens/components/pin_reset.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegistrtionForm extends StatefulWidget {
  const RegistrtionForm({super.key});

  @override
  State<RegistrtionForm> createState() => _RegistrtionFormState();
}

bool _isLoading = false;

class _RegistrtionFormState extends State<RegistrtionForm> {
  File? _image;
  final _formkey = GlobalKey<FormState>();
  String progamme = '';
  String year = '';
  String gender = '';

  final _SurNamecontroller = TextEditingController();
  final _middlenameController = TextEditingController();
  final _firstnamecontroller = TextEditingController();
  final _gendercontroller = TextEditingController();
  final _passwdcontroller = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _enrollController = TextEditingController();
  final _programmeController = TextEditingController();
  final _ghis_ss_Controller = TextEditingController();
  final _infocontrller = TextEditingController();
  final _potfoliocontroller = TextEditingController();
  final _date_controller = TextEditingController();
  final _programmeNotController = TextEditingController();

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
  void initState() {
    _date_controller.text = ""; //set the initial value of text field
    super.initState();
  }

  final GeolocatorPlatform _geoPlatform = GeolocatorPlatform.instance;
  void _appSettings() async {
    final open = await _geoPlatform.openAppSettings();
  }

  void _locationSettings() async {
    final openlocation = await _geoPlatform.openLocationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      //     _isDarkMode ? Color.fromARGB(136, 17, 17, 17) : Colors.white,

      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.asset(
                        height: 150,
                        'assets/images/newmember.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    ConstStrings.passon,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    ConstStrings.warn,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: const Text(
                        ConstStrings.notify,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'PERSONAL INFORMATION',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontStyle: FontStyle.normal),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 90,
                              backgroundImage: FileImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 90,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png')),
                      Positioned(
                        bottom: -10,
                        left: 120,
                        child: IconButton(
                          onPressed: () => _showImageSelectionDialog(),
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    inputType: TextInputType.name,
                    controller: _firstnamecontroller,
                    labelText: 'First Name',
                    icon: Icons.supervised_user_circle_outlined,
                  ),
                  const SizedBox(height: 30),

                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      undoController: UndoHistoryController(),
                      inputFormatters: const [],
                      keyboardType: TextInputType.name,
                      spellCheckConfiguration: const SpellCheckConfiguration(),
                      controller: _middlenameController,
                      obscureText: false,
                      autocorrect: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        labelText: 'Middle Name',
                        prefixIcon: const Icon(Icons.person_add_alt),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  CustomTextField(
                    inputType: TextInputType.name,
                    controller: _SurNamecontroller,
                    labelText: 'Surname',
                    icon: Icons.person,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SelectFieldForm(
                    controller: _gendercontroller,
                    LabelText: 'Gender',
                    HintText: 'Gender',
                    Items: Gender,
                    icons: Icons.generating_tokens_rounded,
                    initialValue: gender,
                    visibledropdown: 2,
                    change: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //  width: MediaQuery.of(context).size.width - 40,
                  //   decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     color: Color.fromARGB(179, 90, 87, 87),)
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        labelText: 'Enter DOB',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date Of Birth is required';
                        }
                        return null;
                      },
                      controller: _date_controller,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            _date_controller.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.none,
                      undoController: UndoHistoryController(),
                      keyboardType: TextInputType.visiblePassword,
                      spellCheckConfiguration: const SpellCheckConfiguration(),
                      maxLength: 15,
                      controller: _passwdcontroller,
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

                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InkWell(
                      child: IntlPhoneField(
                        showCountryFlag: true,
                        enabled: true,
                        dropdownTextStyle:
                            TextField.materialMisspelledTextStyle,
                        dropdownIconPosition: IconPosition.trailing,
                        disableLengthCheck: false,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'GHA',
                        controller: _phoneController,
                        dropdownIcon: const Icon(Icons.phone_in_talk_outlined),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  CustomTextField(
                    maxlenght: 8,
                    inputType: TextInputType.number,
                    controller: _idController,
                    labelText: 'Student Id',
                    icon: Icons.school,
                  ),
                  const SizedBox(height: 30),

                  SelectFieldForm(
                    controller: _programmeController,
                    LabelText: 'Programme',
                    HintText: 'Search Programme of Study',
                    Items: Programmes,
                    icons: Icons.cable_sharp,
                    initialValue: progamme,
                    visibledropdown: 4,
                    change: (value) {
                      setState(() {
                        progamme = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text('IF PROGRAMME NOT FOUND USE THIS FIELD'),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      undoController: UndoHistoryController(),
                      inputFormatters: const [],
                      keyboardType: TextInputType.name,
                      spellCheckConfiguration: const SpellCheckConfiguration(),
                      controller: _programmeNotController,
                      obscureText: false,
                      autocorrect: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        labelText: 'Programme',
                        prefixIcon: const Icon(Icons.pix_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SelectFieldForm(
                    controller: _enrollController,
                    LabelText: 'Year/Level',
                    HintText: 'Select Year/Level',
                    Items: Year,
                    icons: Icons.ads_click_outlined,
                    initialValue: year,
                    visibledropdown: 3,
                    change: (value) {
                      setState(() {
                        year = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    inputType: TextInputType.name,
                    controller: _potfoliocontroller,
                    labelText: 'Potfolio',
                    icon: Icons.portrait_outlined,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    maxlenght: 10,
                    inputType: TextInputType.number,
                    controller: _ghis_ss_Controller,
                    labelText: 'GhIS-SS Pin',
                    icon: Icons.nature_people_sharp,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Optional'),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      maxLength: 300,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      scrollPadding: const EdgeInsets.all(5),
                      controller: _infocontrller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Tell us your expectation',
                        contentPadding: EdgeInsets.all(5),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field required';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          saveUserDataToDatabase();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF273671),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 74, 248, 5),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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

  selectImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: source);

    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<void> _showImageSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 7, 131),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.camera_alt),
                      ),
                      const SizedBox(height: 20),
                      const Text('CAMERA'),
                    ],
                  ),
                ),
                const SizedBox(width: 45),
                GestureDetector(
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 247, 7, 255),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Icon(Icons.photo),
                      ),
                      const SizedBox(height: 20),
                      const Text('GALLERY'),
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

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = storage.ref().child('Profile-Images').child(imageName);
    final uploadTask = ref.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void saveUserDataToDatabase() async {
    try {
      await Firebase.initializeApp();
      final codeExists = await query(_ghis_ss_Controller.text, 'UNIQUE CODE');
      final emailExists = await query(_emailController.text, 'EMAIL');
      final id = await query(_idController.text, 'STUDENT ID');

      if (codeExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'code already used. Please use unique GhIS-SS code  for each registration.'),
            showCloseIcon: true,
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.up,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'oops!! ☹️  Email already exists. Please enter a different email address.'),
            showCloseIcon: true,
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.up,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      if (id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Student already exists. Please enter a different email address.'),
            showCloseIcon: true,
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.up,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (!code.contains('${_ghis_ss_Controller.text}')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Sorry  GhIS-SS code is incorrect!!  Request for valid code from GhIS-SS'),
            showCloseIcon: true,
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.up,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
          ),
        );

        setState(() {
          _isLoading = false;
        });
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your GhIS-SS code is correct'),
          showCloseIcon: true,
          backgroundColor: Color.fromARGB(255, 54, 244, 63),
          dismissDirection: DismissDirection.up,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      );
      String generateUniqueId() {
        return FirebaseFirestore.instance
            .collection('ghis-ss-members')
            .doc()
            .id;
      }

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const PinReset();
        },
      ));

      final uniqueId = generateUniqueId();

      final imageUrl = await _uploadImage();
      final userData = {
        'USER ID': uniqueId,
        'IMAGE URL': imageUrl,
        'FIRST NAME': _firstnamecontroller.text,
        'MIDDLE NAME': _middlenameController.text,
        'SURNAME': _SurNamecontroller.text,
        'GENDER': _gendercontroller.text,
        'EMAIL': _emailController.text,
        'DOB': _date_controller.text,
        'PASSWORD': _passwdcontroller.text,
        'PHONE NUMBER': _phoneController.text,
        'STUDENT ID': _idController.text,
        'LEVEL/YEAR': _enrollController.text,
        'PROGRAM STUDY': _programmeController.text,
        'UNIQUE CODE': _ghis_ss_Controller.text,
        'POTFOLIO': _potfoliocontroller.text,
        'MEMBER EXPECTATION': _infocontrller.text
      };

      await FirebaseFirestore.instance
          .collection('ghis-ss-members')
          .add(userData);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('      Congratulation \n     User data saved successfully'),
          showCloseIcon: true,
          backgroundColor: Color.fromARGB(255, 54, 244, 54),
          dismissDirection: DismissDirection.up,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          content: Text('Failed to save user data: $error'),
          showCloseIcon: true,
          backgroundColor: Colors.red,
          dismissDirection: DismissDirection.up,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      );
    }
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {},
      );
      Widget continueButton = TextButton(
        child: const Text("Continue"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PinReset(),
            ),
          );
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("AlertDialog"),
        content: const Text("Would you like to reset your GhIS-SS pin?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  Future<bool> query(String code, String field) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ghis-ss-members')
        .where(field, isEqualTo: code)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
