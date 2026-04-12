// ignore_for_file: strict_top_level_inference, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';
import 'package:to_do_app/shared/components/custom_text_field.dart';
import 'package:to_do_app/shared/components/get_loading.dart';
import 'package:to_do_app/shared/components/title_text_field.dart';
import 'package:to_do_app/shared/constants.dart';

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
  GlobalKey<FormState> formKey = GlobalKey();
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
      body: tasks.isEmpty ? GetLoading() : screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                time: timeController.text,
                title: titleController.text,
                date: dateController.text,
              ).then((value) {
                getDataFromDataBase(database).then((value) {
                  Navigator.of(context).pop();
                  isBottomSheetShown = false;
                  setState(() {
                    fabIcon = Icons.edit;
                    tasks = value;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TitleField(titleController: titleController),
                          SizedBox(height: 15),
                          CustomField(
                            isReadOnly: true,
                            onTap: () {
                              showTime(context);
                            },
                            controller: timeController,
                            validator: timeValidation,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            type: TextInputType.datetime,
                            label: "Task Time",
                            prefixIcon: Icons.watch_later_outlined,
                          ),
                          SizedBox(height: 15),
                          CustomField(
                            isReadOnly: true,
                            onTap: () {
                              showDate(context);
                            },
                            controller: dateController,
                            validator: dateValidation,
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
                  ),
                )
                .closed
                .then((value) {
                  isBottomSheetShown = false;
                  setState(() {
                    fabIcon = Icons.edit;
                  });
                });
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

  String? dateValidation(value) {
    if (value!.isEmpty) {
      return "Task Date must not be empty";
    }
    return null;
  }

  Future<Null> showDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.parse('2030-12-31'),
    ).then((value) {
      dateController.text = DateFormat.yMMMd().format(value!);
    });
  }

  String? timeValidation(value) {
    if (value!.isEmpty) {
      return "Task Time must not be empty";
    }
    return null;
  }

  void showTime(BuildContext context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      value,
    ) {
      timeController.text = value!.format(context).toString();
    });
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
      onOpen: (database) {},
    );
  }

  Future insertToDatabase({
    required String time,
    required String title,
    required String date,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
            'INSERT INTO tasks (title,date,time,status)VALUES ("$title","$date","$time","new")',
          )
          .then((value) {
            print("$value inserted successfully");
          })
          .catchError((error) {
            print("error occures");
          });
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
