import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final IconData prefixIcon;
  final String label;
  final InputBorder border;
  final TextInputType type;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final GestureTapCallback? onTap;
  const CustomField({
    super.key,
    required this.controller,
    required this.validator,
    required this.border,
    required this.type,
    required this.label,
    required this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: label,
        focusedBorder: border,
        enabledBorder: border,
        floatingLabelStyle: TextStyle(color: Colors.blue),
      ),
      onTap: onTap,
      keyboardType: type,
      controller: controller,
      validator: validator,
    );
  }
}
