// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  final Map taskModel;
  TaskItem(this.taskModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              '${taskModel['time']}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${taskModel['title']}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${taskModel['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            onPressed: () {
              AppCubit.get(
                context,
              ).updateData(status: 'done', id: taskModel['id']);
            },
            icon: Icon(Icons.check_box, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(
                context,
              ).updateData(status: 'archived', id: taskModel['id']);
            },
            icon: Icon(Icons.archive, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
