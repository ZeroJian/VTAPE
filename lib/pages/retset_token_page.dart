import 'package:flutter/material.dart';

import 'package:ovprogresshud/progresshud.dart';


import 'package:vtape/utils/storage.dart';


class ResetTokenPage extends StatefulWidget {
  ResetTokenPage({Key key}) : super(key: key);

  _ResetTokenPage createState() => _ResetTokenPage();
}

class _ResetTokenPage extends State<ResetTokenPage> {


  String text;

    Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildContent()
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      Container(
        padding: EdgeInsets.only(bottom: 20),
        child:  Text(
          """
由于未发现移动端登录接口, 如果出现需要登录提示, 可在此重新设置 Token.
可在 https://v.shmy.tech 地址注册登录查看返回的 Token.
格式为 [Bearer xxxxxx] 只保留 xxxxxx 内容更新即可.
          """,
          style: TextStyle(
            color: Theme.of(context).textTheme.title.color,
            fontSize: 15,
            fontWeight: FontWeight.bold
            ),
          ),
      ),

      Container(
        padding: EdgeInsets.only(bottom: 20),
        child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          counterStyle: TextStyle(color: Colors.white),
          hintText: "输入新获取的有效 Token",
          hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle.color),
          filled: true,
          fillColor: Theme.of(context).unselectedWidgetColor,
          border: InputBorder.none
        ),
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLines: 6,
        style: TextStyle(color: Theme.of(context).textTheme.title.color),
        onChanged: (value) {
          this.text = value;
        }
       ),
      ),

      _buildButton(title: "更新 Token")
    ];

  }


  Widget _buildButton({String title}) {
    return Container(
      height: 45,
      width: double.infinity,
      child: FlatButton(
        color: Theme.of(context).highlightColor,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.title.color,
            fontSize: 18
            ),
          ),
        onPressed: () => _buttonAction(),
      ),
    );
  }

  void _buttonAction() {
    if (text.isEmpty) {
      return;
    }
    // 移除 Bearer 和 空格
    text = text.replaceAll("Bearer", "");
    text = text.replaceAll(" ", "");

    Storage.token = text;

    Progresshud.showSuccessWithStatus("Token 更新成功, 请重新进入需要登录的页面");

    Navigator.pop(context);

  }

}