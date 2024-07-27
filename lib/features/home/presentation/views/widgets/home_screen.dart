import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List screens = [
    const Center(
      child: Text('Tasks'),
    ),
    const Center(
      child: Text('Done'),
    ),
    const Center(
      child: Text('Archive'),
    ),
  ];
  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(titles[currentIndex], style: Styles.appbar),
        ),
        body: screens.elementAt(currentIndex),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          elevation: 0,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return screens[index];
            }));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return screens[index];
            }));
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'Done',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: 'Archive',
            ),
          ],
        ));
  }
}
