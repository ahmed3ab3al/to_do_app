import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/custom_loading_item.dart';
import '../../view_models/cubit/cubit.dart';
import '../../view_models/cubit/states.dart';

class GetLoading extends StatelessWidget {
  const GetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) =>
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                CustomLoadingItem(
                  width: 80,
                  height: 80,
                  circle: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLoadingItem(width: 150, height: 12),
                    SizedBox(
                      height: 15,
                    ),
                    CustomLoadingItem(width: 100, height: 8),
                  ],
                )
              ],
            ),
          ),
          separatorBuilder: (context, index) =>
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                    height: 1,
                    color: ColorManager.greyColor,
                    width: double.infinity),
              ),
          itemCount: 6,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,

        );
      },
    );
  }
}
