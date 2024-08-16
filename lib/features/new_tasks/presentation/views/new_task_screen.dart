import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/widgets/build_task_item.dart';
import 'package:to_do_app/features/home/presentation/view_models/cubit/cubit.dart';

import '../../../../core/utils/colors.dart';
import '../../../home/presentation/view_models/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) => BuildTaskItem(
                  newTaskModel: HomeCubit.get(context).newTasks[index],
                ),
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20),
                  child: Container(
                      height: 1,
                      color: ColorManager.greyColor,
                      width: double.infinity),
                ),
            itemCount: HomeCubit.get(context).newTasks.length);
      },
    );
  }
}
