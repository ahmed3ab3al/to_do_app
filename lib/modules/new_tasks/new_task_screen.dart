import 'package:flutter/material.dart';

import '../../shared/components/task_item.dart';
import '../../shared/constants.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
    // ListView.separated(
    //   itemBuilder: (context, index) => TaskItem(tasks[index]),
    //   separatorBuilder: (context, index) => Padding(
    //     padding: const EdgeInsetsDirectional.only(start: 20),
    //     child: Container(
    //       color: Colors.grey[300],
    //       width: double.infinity,
    //       height: 1,
    //     ),
    //   ),
    //   itemCount: tasks.length,
    // );
  }
}
