// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isObscured;
  final int? minlenght;
  final int? maxlenght;
  final TextInputType? inputType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isObscured = false,
    this.maxlenght,
    this.inputType,
    this.minlenght,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: TextCapitalization.none,
        undoController: UndoHistoryController(),
        keyboardType: inputType,
        spellCheckConfiguration: const SpellCheckConfiguration(),
        maxLength: maxlenght,
        controller: controller,
        obscureText: isObscured,
        autocorrect: true,
        decoration: InputDecoration(
          fillColor: Colors.grey,
          labelText: labelText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  width: 0.3, strokeAlign: BorderSide.strokeAlignCenter)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }
}
