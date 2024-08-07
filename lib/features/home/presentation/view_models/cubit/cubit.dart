import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/features/home/presentation/view_models/cubit/states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

}