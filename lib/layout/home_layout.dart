// ignore_for_file: strict_top_level_inference, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/components/custom_text_field.dart';
import 'package:to_do_app/shared/components/get_loading.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertDataState) {
            Navigator.of(context).pop();
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
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
            body: state is GetDataLoadingState
                ? GetLoading()
                : AppCubit.get(context).screens[AppCubit.get(
                    context,
                  ).currentIndex],
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.blue,
              onPressed: () {
                if (AppCubit.get(context).isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                      time: timeController.text,
                      title: titleController.text,
                      date: dateController.text,
                    );
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
                        AppCubit.get(
                          context,
                        ).changeSheetShown(isShown: false, icon: Icons.edit);
                      });
                  AppCubit.get(
                    context,
                  ).changeSheetShown(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(AppCubit.get(context).fabIcon, color: Colors.white),
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
