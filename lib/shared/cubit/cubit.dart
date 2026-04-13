import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';
import 'package:to_do_app/shared/constants.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  late Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  int currentIndex = 0;
  List<String> title = ["New Tasks", 'Done Tasks', 'Archived Tasks'];
  List<Map> tasks = [];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(BottomNavChangeState());
  }

  void createDatabase() {
    openDatabase(
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
      onOpen: (database) {
        getDataFromDataBase(database).then((value) {
          tasks = value;
          emit(GetDataState());
        });
      },
    ).then((value) {
      database = value;
      emit(CreateDataState());
    });
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

  void changeSheetShown({required bool isShown, required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(BottomsheetChangeState());
  }
}
