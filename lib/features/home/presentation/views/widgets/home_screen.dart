// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/features/archived_tasks/presentation/views/widgets/archived_task_screen.dart';
import 'package:to_do_app/features/done_tasks/presentation/views/widgets/done_task_screen.dart';
import 'package:to_do_app/features/new_tasks/presentation/views/widgets/new_task_screen.dart';

import '../../../../../core/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    createDatabase();
    super.initState();
  }
  List screens = [
   const NEWTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen()
  ];
  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];
late Database database;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(titles[currentIndex], style: Styles.appbar),
        ),
        body: screens[currentIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            insertToDatabase();
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          elevation: 0,
          selectedItemColor: Colors.blue,
          onTap: (index) {
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


  void createDatabase() async
  {
     database = await openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database,version) {
        database.execute('create Table ToDo (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT,time TEXT,status TEXT)')
            .then((value){
              print('done');
        })
            .catchError((error){
              print('error is ${error.toString()}');
        });
      },
      onOpen: (database){
        print('done 2');
      }
    );
  }

  void insertToDatabase() async
  {
   await database.transaction((txn) async{
      txn.rawInsert('INSERT INTO ToDo (title,date,time,status) VALUES ("new task","2022-12-12","12:12:12","new")')
      .then((value){
        print('$value inserted successfully');
      }).catchError((onError){});
      return null;
    });

  }
}
