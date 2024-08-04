import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/core/widgets/build_task_item.dart';

class NewTaskScreenBody extends StatelessWidget {
  const NewTaskScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: ( context, index) =>  BuildTaskItem(newTaskModel: tasks[index], ),
        separatorBuilder: ( context, index) =>  Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Container(
              height: 1,
              color: Colors.grey[300],
              width: double.infinity),
        ),
        itemCount: tasks.length);

  }
}


