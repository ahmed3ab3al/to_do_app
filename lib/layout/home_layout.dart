import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';
import 'package:to_do_app/shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  late Database database;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> title = ["New Tasks", 'Done Tasks', 'Archived Tasks'];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          title[currentIndex],
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_outlined),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'archived',
          ),
        ],
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.of(context).pop();
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomField(
                      controller: titleController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title must not be empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      type: TextInputType.text,
                      label: "Title",
                      prefixIcon: Icons.title,
                    ),
                    SizedBox(height: 15),
                    CustomField(
                      onTap: () {},
                      controller: timeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Task Time must not be empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      type: TextInputType.datetime,
                      label: "Task Time",
                      prefixIcon: Icons.watch_later_outlined,
                    ),
                    SizedBox(height: 15),
                    CustomField(
                      onTap: () {},
                      controller: dateController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Task Date must not be empty";
                        }
                        return null;
                      },
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      type: TextInputType.datetime,
                      label: "Task Date",
                      prefixIcon: Icons.calendar_month_outlined,
                    ),
                  ],
                ),
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon, color: Colors.white),
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status Text)',
            )
            .then((value) {
              print('database created');
            })
            .catchError((error) {});
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) async {
      txn
          .rawInsert(
            'INSERT INTO tasks (title,date,time,status)VALUES ("new tasks","1/1/2000","16:25","new")',
          )
          .then((value) {
            print("$value inserted successfully");
          })
          .catchError((error) {
            print("error occures");
          });
    });
  }
}
