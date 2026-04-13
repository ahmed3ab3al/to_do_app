// ignore_for_file: strict_top_level_inference, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/custom_text_field.dart';
import 'package:to_do_app/shared/components/get_loading.dart';
import 'package:to_do_app/shared/constants.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  late Database database;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.blue,
              title: Text(
                AppCubit.get(context).title[AppCubit.get(context).currentIndex],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              selectedItemColor: Colors.blue,
              onTap: (index) {
                AppCubit.get(context).changeBottomNav(index);
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
            body: tasks.isEmpty
                ? GetLoading()
                : AppCubit.get(context).screens[AppCubit.get(
                    context,
                  ).currentIndex],
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
                        // setState(() {
                        //   fabIcon = Icons.edit;
                        //   tasks = value;
                        // });
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
                        // setState(() {
                        //   fabIcon = Icons.edit;
                        // });
                      });
                  isBottomSheetShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(fabIcon, color: Colors.white),
            ),
          );
        },
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
            .then((value) {})
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
          .then((value) {})
          .catchError((error) {});
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}

class TitleField extends StatelessWidget {
  const TitleField({super.key, required this.titleController});
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return CustomField(
      controller: titleController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Task Title must not be empty";
        }
        return null;
      },
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      type: TextInputType.text,
      label: "Title",
      prefixIcon: Icons.title,
      isReadOnly: false,
    );
  }
}
