import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vtape/utils/api.dart';
import 'package:vtape/pages/search_page.dart';
import 'package:vtape/pages/views/video_list_widget.dart';
import 'package:vtape/pages/user_page.dart';
import 'package:vtape/utils/storage.dart';

class HomeListPage extends StatefulWidget {
  @override
  _HomeListPageState createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> with SingleTickerProviderStateMixin {

  List _tabs = ["HOT","电影","电视剧","综艺","动漫"];

  TabController _tabController;
  TabBarView tabbarView;
  List<VideoListWidget> widgetList = [];

  @override
  void initState() {
    super.initState();
    print("Home_List_Page initState");
    _tabController = TabController(length: _tabs.length, vsync: this);

    Storage.initCacheToken();
    
    widgetList = [
      VideoListWidget.hot(context: context, url: API_HOT_VIDEO_LIST), 
      VideoListWidget.typeList(context: context, url: API_Movie_List),
      VideoListWidget.typeList(context: context, url: API_TV_List),
      VideoListWidget.typeList(context: context, url: API_TVSHOW_List),
      VideoListWidget.typeList(context: context, url: API_COMIC_List),
      ];

    tabbarView = TabBarView(
      controller: _tabController,
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {

    var materialApp = MaterialApp(
          home: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.color,
              title: Text(
                "VTAPE",
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
                // style: TextStyle(color: Colors.yellow),
              ),
              centerTitle: false,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _pushUser(),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _pushSearch(),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabs.map((f) => Tab(text: f,)).toList(),
                labelColor: Theme.of(context).highlightColor,
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                indicatorColor: Theme.of(context).highlightColor,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Theme.of(context).textTheme.subtitle.color,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            body: tabbarView,
          ),
    );
    
    return materialApp;
  }

  _pushSearch() {
    showSearch(context: context, delegate: AppSearchBarDelegate(hintText: "搜索影片名称"));
  }

  _pushUser() {
     Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return UserPage();
      })
    );
  }

}