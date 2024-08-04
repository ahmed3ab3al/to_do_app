import 'package:flutter/material.dart';

class BuildTaskItem extends StatelessWidget {
  final Map newTaskModel;
  const BuildTaskItem({
    super.key, required this.newTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.withOpacity(.8),
              child:  Text(newTaskModel['time'],style: const TextStyle(color: Colors.white),)),

          const SizedBox(width: 20,),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(newTaskModel['title'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),),
              Text(newTaskModel['date'],style: const TextStyle(fontSize: 15,color: Colors.grey),),

            ],
          )
        ],
      ),
    );
  }
}