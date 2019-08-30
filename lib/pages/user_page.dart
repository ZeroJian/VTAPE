import 'package:flutter/material.dart';



import 'package:vtape/pages/video_history_page.dart';
import 'package:vtape/pages/about_page.dart';
import 'package:vtape/pages/browser_page.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  
  List<String> listData = ["播放记录", "GitHub", "Blog", "关于"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
        ),
          body: _buildListView(),
    );
  }


  Widget _buildListView() {
    return ListView.separated(
      itemCount: listData.length,
      separatorBuilder: (context, index) {
        return Divider(height: 1, color: Theme.of(context).unselectedWidgetColor,);
      },
      itemBuilder: (context, index) {
        return _buildRow(listData[index], index);
      },
    );
  }

  Widget _buildRow(String item, int index) {
    return GestureDetector(
      onTap: () {
        _listTap(index);
      },
      behavior: HitTestBehavior.opaque,
      child: _buildContainer(item),
    );
  }

  Widget _buildContainer(String item) {
    return Container(
      // padding: EdgeInsets.all(12.0),
      padding: EdgeInsets.only(left: 12, right: 12),
      height: 46,
      alignment: Alignment.centerLeft,
      color: Theme.of(context).unselectedWidgetColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.title.color),
            ),
          Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).textTheme.title.color,
            ),
        ],
      )
    );
  }

  _listTap(int index) {
    switch (index) {
      case 0:
        _pushPage(VideoHistoryPage());
        break;
      case 1:
        _pushPage(BrowserPage(url: "https://github.com/ZeroJian/VTAPE",));
        break;
      case 2:
        _pushPage(BrowserPage(url: "http://zerojian.github.io/Project/",));
        break;
      case 3:
        _pushPage(AboutPage());
        break;
      default:
        break;
    }
  }


  _pushPage(Widget page) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return page;
      })
    );
  }
}