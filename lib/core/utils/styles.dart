import 'package:flutter/material.dart';
import 'package:to_do_app/core/utils/colors.dart';

abstract class Styles {


  static TextStyle appbar =  const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ColorManager.whiteColor
  );

  static TextStyle title =  const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
  );

  static TextStyle subtitle =  const TextStyle(
      fontSize: 15,
      color: Colors.grey
  );
}

