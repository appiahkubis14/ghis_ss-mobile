// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghis_ss/src/common/customField.dart';
import 'package:ghis_ss/src/features/screens/auth_screens/index.dart';

class PinReset extends StatefulWidget {
  const PinReset({super.key});

  @override
  State<PinReset> createState() => _PinResetState();
}

class _PinResetState extends State<PinReset> {
  final TextEditingController _pinResetController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final TextEditingController _oldPinController = TextEditingController();
  bool _loading = false;

  Future<void> _updatePin() async {
    if (_pinResetController.text.isEmpty ||
        _confirmPinController.text.isEmpty ||
        _oldPinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_pinResetController.text != _confirmPinController.text) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('PINs entered does not match'),
          );
        },
      );
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      var collection = FirebaseFirestore.instance.collection('ghis-ss-members');
      var querySnapshots = await collection.get();
      for (var doc in querySnapshots.docs) {
        for (var value in doc.data().values) {
          if (value == _oldPinController.text) {
            await doc.reference.update({
              'UNIQUE CODE': '${_confirmPinController.text}',
            });
          }
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Center(child: Text('Pin Reset')),
            content: Text('Congratulation PIN reset successful'),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Failed to reset PIN. Please try again.'),
          );
        },
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GhIS-SS PIN RESET')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Text(
                //   'GhIS-SS PIN RESET',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                const SizedBox(height: 40),
                CustomTextField(
                  maxlenght: 10,
                  inputType: TextInputType.number,
                  controller: _oldPinController,
                  labelText: 'Original pin',
                  icon: Icons.security,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  maxlenght: 8,
                  inputType: TextInputType.number,
                  controller: _pinResetController,
                  labelText: 'New',
                  icon: Icons.security,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  maxlenght: 8,
                  inputType: TextInputType.number,
                  controller: _confirmPinController,
                  labelText: 'Confirm',
                  icon: Icons.security,
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _updatePin,
                  icon: const Icon(Icons.update),
                  label: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CupertinoActivityIndicator(),
                        )
                      : const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
