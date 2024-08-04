import 'package:flutter/material.dart';
import 'package:to_do_app/features/new_tasks/presentation/views/widgets/new_task_screen_body.dart';

class NewTaskScreenView extends StatelessWidget {
  const NewTaskScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NewTaskScreenBody()
    );
  }
}
