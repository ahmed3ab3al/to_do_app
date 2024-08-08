// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/core/widgets/custom_text_form_field.dart';
import 'package:to_do_app/features/home/presentation/view_models/cubit/states.dart';
import '../../../../core/utils/styles.dart';
import '../view_models/cubit/cubit.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();


  late Database database;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => HomeCubit(),
  child: BlocConsumer<HomeCubit, HomeStates>(
  listener: (context, state) {},
  builder: (context, state) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue.withOpacity(.75),
          title: Text(HomeCubit.get(context).titles[
            HomeCubit.get(context).currentIndex], style: Styles.appbar),
        ),
        body:
        // tasks.isEmpty
        //     ? const CustomLoadingItem(
        //     width: double.infinity, height: double.infinity)
        //     :
        HomeCubit.get(context).screens[HomeCubit.get(context).currentIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue.withOpacity(.7),
          onPressed: () {
            if (isBottomSheetShown) {
              if (formKey.currentState!.validate()) {
                insertToDatabase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text)
                    .then((value) {
                  getDataFromDatabase(database).then((value) {
                    Navigator.of(context).pop();
                    // setState(() {
                    //   isBottomSheetShown = false;
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
                    color: Colors.white.withOpacity(.001),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextFormFiled(
                                customController: titleController,
                                type: TextInputType.text,
                                label: ' Task Title',
                                prefix: Icons.title),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFiled(
                                customController: timeController,
                                type: TextInputType.datetime,
                                label: ' Task Time',
                                prefix: Icons.watch_later_outlined,
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) {
                                    timeController.text = value!
                                        .format(context)
                                        .toString();
                                  });
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextFormFiled(
                                customController: dateController,
                                type: TextInputType.datetime,
                                label: ' Task Date',
                                prefix: Icons.calendar_today,
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse(
                                          '2025-12-31'))
                                      .then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd()
                                            .format(value!);
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  elevation: 30)
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
        bottomNavigationBar:  BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: HomeCubit.get(context).currentIndex,
          elevation: 0,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            HomeCubit.get(context).changeIndex(index);
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
        ),
    );
  },
),
);
  }

  void createDatabase() async {
    database = await openDatabase('ToDo.db', version: 1,
        onCreate: (database, version) {
          database
              .execute(
              'create Table ToDo (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT,time TEXT,status TEXT)')
              .then((value) {
            print('done');
          }).catchError((error) {
            print('error is ${error.toString()}');
          });
        }, onOpen: (database) {
          print('opened');
        });
  }

  Future insertToDatabase(
      {required String title,
        required String date,
        required String time}) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO ToDo (title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((onError) {});
      return null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM ToDo');
  }
}


