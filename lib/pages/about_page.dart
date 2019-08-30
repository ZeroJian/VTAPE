import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: ListView(
        children: <Widget>[
          _buildLogo(context),
          // _buildVersion(context),
          _buildDes(context)
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "images/logo_152.png",
              height: 80,
              width: 80,
              ),
          ),
          _buildVersion(context)
        ],
      ),
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      color: Theme.of(context).backgroundColor,
      child: Text(
        "v1.0.0",
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.title.color
          ),
        ),
      );
  }

  Widget _buildDes(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 12, right: 12),
      color: Theme.of(context).backgroundColor,
      child: Text(
        """
VTAPE
一款使用 Flutter 开发的视频点播 App, 所有资源都来自网上, 只做内部技术交流使用

此项目已经开源
GitHub: https://github.com/ZeroJian/VTAPE
Blog: http://zerojian.github.io/Project/ 
联系方式: zj17223412@outlook.com
        """,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.title.color,
          wordSpacing: 5,
          height: 1.5
          ),
        ),
      );
  }
}