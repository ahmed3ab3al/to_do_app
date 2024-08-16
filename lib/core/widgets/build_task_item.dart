import 'package:flutter/material.dart';
import 'package:to_do_app/core/utils/styles.dart';

import '../../features/home/presentation/view_models/cubit/cubit.dart';

class BuildTaskItem extends StatelessWidget {
  final Map newTaskModel;

  const BuildTaskItem({
    super.key,
    required this.newTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(newTaskModel['id'].toString()),
      onDismissed: (direction) {
        HomeCubit.get(context).deleteData(
          id: newTaskModel['id'],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.withOpacity(.8),
                child: Text(
                  newTaskModel['time'],
                  style: const TextStyle(color: Colors.white),
                )),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(newTaskModel['title'], style: Styles.title),
                  Text(
                    newTaskModel['date'],
                    style: Styles.subtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
                onPressed: () {
                  HomeCubit.get(context).updateData(
                    status: 'done',
                    id: newTaskModel['id'],
                  );
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.lightGreen,
                )),
            IconButton(
                onPressed: () {
                  HomeCubit.get(context).updateData(
                    status: 'archive',
                    id: newTaskModel['id'],
                  );
                },
                icon: const Icon(
                  Icons.archive_outlined,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
  }
}
