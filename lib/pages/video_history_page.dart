import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:vtape/pages/video_detail_page.dart';
import 'package:vtape/utils/storage.dart';
import 'package:vtape/models/history_video_model.dart';


class VideoHistoryPage extends StatefulWidget {
  VideoHistoryPage({Key key}) : super(key: key);

  _VideoHistoryPageState createState() => _VideoHistoryPageState();
}

class _VideoHistoryPageState extends State<VideoHistoryPage> {

  List<StorageVideoHistory> list = [];

  @override
  void initState() {
    super.initState();
    Storage.videoHistory
    .then((value){
      list = value.reversed.toList();
      setState(() {
        
      });
    });
  }

  _pushDetail(StorageVideoHistory history) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return VideoDetailPage(history: history,);
      })
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("播放记录"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        separatorBuilder: (context, index) {
          return Divider(color: Theme.of(context).scaffoldBackgroundColor, height: 12,);
        },
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _buildRow(list[index]);
        },
      ),
    );
  }

  Widget _buildRow(StorageVideoHistory item) {
    return GestureDetector(
      onTap: () {
        _pushDetail(item);
      },
      behavior: HitTestBehavior.opaque,
      child: _buildContainer(item),
    );
  }

  Widget _buildContainer(StorageVideoHistory item) {
    return Container(
      // padding: EdgeInsets.all(12.0),
      color: Theme.of(context).backgroundColor,
      child: Row(
        // 设置子容器从顶部开始布局
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLeftImage(item),
          _buildRightContainer(item),
        ],
      ),
    );
  }

  Widget _buildLeftImage(StorageVideoHistory item) {
    return Container(
      color: Theme.of(context).unselectedWidgetColor,
      child: Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 150,
            child: CachedNetworkImage(
                        imageUrl: item.pic ?? "",
                        placeholder: (context, url) {
                          return Center(
                            child: Image.asset(
                              "images/logo_min200.png",
                              width: 30,
                              ),
                          );
                        },
                        // width: 100,
                        // height: 150,
                        fit: BoxFit.cover,
                      ),
          ),
        ],
      ),
    );
  }

   Widget _buildRightContainer(StorageVideoHistory item) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
                  
          Container(
            padding: const EdgeInsets.only(left: 12, top: 12, bottom: 6),
            child: Text(
              item.name,
              style: TextStyle(color: Theme.of(context).textTheme.title.color, fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 12, bottom: 6.0),
            child: Text(
              item.sourceName,
              style: TextStyle(color: Theme.of(context).textTheme.subtitle.color, fontSize: 15),
            ),
          ),        

          Container(
            padding: const EdgeInsets.only(left: 12, bottom: 6.0),
            child: Text(
              item.playTime(),
              style: TextStyle(color: Theme.of(context).textTheme.subtitle.color, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

}
