import 'package:flutter/material.dart';

class NoTaskScreen extends StatelessWidget {
  const NoTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu, size: 100, color: Colors.grey),
          Text(
            'No Tasks Yet , Please Add Some Tasks',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
