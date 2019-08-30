import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vtape/pages/home_list_page.dart';
import 'package:vtape/utils/app_style.dart';

void main() => runApp(Vtape());


class Vtape extends StatefulWidget {
  Vtape({Key key}) : super(key: key);

  _VtapeState createState() => _VtapeState();
}

class _VtapeState extends State<Vtape> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VTAPE",
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeListPage(),
    );
  }

}



