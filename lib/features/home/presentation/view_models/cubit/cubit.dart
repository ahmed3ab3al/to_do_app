// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/features/home/presentation/view_models/cubit/states.dart';

import '../../../../archived_tasks/presentation/views/archived_task_screen.dart';
import '../../../../done_tasks/presentation/views/done_task_screen.dart';
import '../../../../new_tasks/presentation/views/new_task_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  late Database database;

  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen()
  ];
  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('ToDo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'create Table ToDo (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('done');
      }).catchError((error) {
        print('error is ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('opened database successfully');
    }).then((value) {
      database = value;
      print('done database');
      emit(CreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO ToDo (title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(InsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {});
      return null;
    });
  }

  void getDataFromDatabase(database)  {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];


    emit(GetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM ToDo').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE ToDo SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }


  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
