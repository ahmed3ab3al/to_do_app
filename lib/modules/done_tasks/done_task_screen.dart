import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/no_task_screen.dart';
import 'package:to_do_app/shared/components/task_item.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../../shared/cubit/cubit.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppCubit.get(context).doneTasks.isEmpty
            ? NoTaskScreen()
            : ListView.separated(
                itemBuilder: (context, index) =>
                    TaskItem(AppCubit.get(context).doneTasks[index]),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    height: 1,
                  ),
                ),
                itemCount: AppCubit.get(context).doneTasks.length,
              );
      },
    );
  }
}
