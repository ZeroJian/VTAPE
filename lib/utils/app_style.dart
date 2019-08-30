import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vtape/utils/color_util.dart';

ThemeData appTheme() {
  Color white = Colors.white;

  return ThemeData(
    platform: TargetPlatform.iOS,

    appBarTheme: AppBarTheme(
      color: VtapeColor.foreground,
      textTheme: TextTheme(
        title: TextStyle(color: white, fontSize: 22),
        button: TextStyle(color: white)
      ),
      actionsIconTheme: IconThemeData(
        color: white
      ),
      iconTheme: IconThemeData(
        color: white
      ),
          // color: Colors.white
    ),
    highlightColor: VtapeColor.highlight,
    primaryColor: white,
    backgroundColor: VtapeColor.foreground,
    unselectedWidgetColor: VtapeColor.foregroundLight,
    scaffoldBackgroundColor: VtapeColor.back,
    textTheme: TextTheme(
      button: TextStyle(color: white),
      title: TextStyle(color: white),
      subtitle: TextStyle(color: VtapeColor.subTitle)
    ),
    primaryTextTheme: TextTheme(
      button: TextStyle(color: white),
      title: TextStyle(color: white),
      subtitle: TextStyle(color: VtapeColor.subTitle)
    ),
    primaryColorBrightness: Brightness.dark
  );
}
