import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/custom_text_field.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key, required this.titleController});

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return CustomField(
      isReadOnly: false,
      controller: titleController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Task Title must not be empty";
        }
        return null;
      },
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      type: TextInputType.text,
      label: "Title",
      prefixIcon: Icons.title,
    );
  }
}
