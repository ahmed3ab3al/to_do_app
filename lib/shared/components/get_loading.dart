import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/custom_loading.dart';

class GetLoading extends StatelessWidget {
  const GetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CustomLoadingItem(width: 100, height: 100, circle: 100),
            SizedBox(width: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLoadingItem(width: 150, height: 10),
                SizedBox(height: 12),
                CustomLoadingItem(width: 100, height: 8),
              ],
            ),
          ],
        ),
      ),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 20),
        child: Container(
          height: 1,
          color: Colors.grey[300],
          width: double.infinity,
        ),
      ),
      itemCount: 5,
      shrinkWrap: true,
    );
  }
}
