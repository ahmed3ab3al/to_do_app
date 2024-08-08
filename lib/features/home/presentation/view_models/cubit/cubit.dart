import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/features/home/presentation/view_models/cubit/states.dart';

import '../../../../archived_tasks/presentation/views/widgets/archived_task_screen.dart';
import '../../../../done_tasks/presentation/views/widgets/done_task_screen.dart';
import '../../../../new_tasks/presentation/views/widgets/new_task_screen_body.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List <Widget>screens = [
    const NewTaskScreenBody(),
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

}