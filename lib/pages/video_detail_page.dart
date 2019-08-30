import 'package:flutter/material.dart';

import 'package:ovprogresshud/progresshud.dart';

import 'package:vtape/models/hot_list_model.dart';
import 'package:vtape/utils/api.dart';
import 'package:vtape/utils/http_util.dart';
import 'package:vtape/utils/storage.dart';
import 'package:vtape/utils/video_player.dart';
import 'package:vtape/models/history_video_model.dart';
import 'package:vtape/pages/retset_token_page.dart';


class VideoDetailPage extends StatefulWidget {

  int id;

  StorageVideoHistory history;

  VideoDetailPage({this.id, this.history, Key key}) : super(key: key);

  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> with SingleTickerProviderStateMixin {

  VideoModel videoModel;

  int playSessionIndex = 0;

  int showIndex = 0;

  final AppVideoPlayer player = AppVideoPlayer(); 

  @override
  void initState() {
    super.initState();

    // 自动播放下一集时刷新播放列表选择的集数
    player.playerAutoNextAction((index) {
      setState(() {
      });
    });
    
    _requestDataSource();
  }

  @override
  void dispose() {
    _pageDispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {

    Widget scrollView = CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            _buildVideo(),
            _buildSegment()
          ])
        ),
        SliverList(
          delegate: SliverChildListDelegate(
              _buildSegmentContent(showIndex)
          ),
        ),
      ],
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: scrollView
        )
    );
  }

  Widget _buildVideo() {
    var ready = false;
    if (videoModel != null) {
      ready = true;
    }
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 250,
      child: ready ?
       player.playerRatio(backgroudColor: Theme.of(context).scaffoldBackgroundColor) 
      : Container(),
    );
  }

  Widget _buildSegment() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Row(
        children: _buildSegmentButtonList(),
      ),
    );
  }

  List<Widget> _buildSegmentButtonList() {
    List<Widget> widgetList = [];
    FlatButton button =  _buildSegmentButton("介绍", 0);
    widgetList.add(button);

    List<List<VideoLink>> videoLink2d = videoModel?.getResourceVideoLinks() ?? [];

    for (var i = 0; i < videoLink2d.length; i++) {
      String title = i == 0 ? "片源" : "片源${i+1}";
      FlatButton button =  _buildSegmentButton(title, i + 1);
      widgetList.add(button);
    }
    return widgetList;
  }

  Widget _buildSegmentButton(String title, int index) {
    return FlatButton(
            child: Text(
              title,
              style: TextStyle(
                color: _makeColor(showIndex == index),
                fontSize: 20,
                ),
              ),
            onPressed: ((){ 
              this._segmentPressed(index);
            }),
    );
  }

  _segmentPressed(int index) {
    if (showIndex == index) {
      return;
    }
    showIndex = index;
    setState(() {
    });
  }

  List<Widget> _buildSegmentContent(int showIndex) {
    if (showIndex == 0) {
      return _buildSegmentDes();
    } else {
      return _buildSegmentSource(showIndex - 1);
    }
  }

  List<Widget> _buildSegmentDes() {
    return [_buildName(), _buildDes()];
  }

  List<Widget> _buildSegmentSource(int sessionIndex) {
    var links = videoModel?.getResourceVideoLinks()[sessionIndex] ?? [];

    ListView listView =  ListView.builder(
      shrinkWrap: true,     // fix 嵌套不显示问题       
      physics: NeverScrollableScrollPhysics(), // fix 滚动冲突问题
      itemCount: links.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            links[index].name,
            style: TextStyle(
              fontSize: 18,
              color: _makeColor(player.playIndex == index && sessionIndex == playSessionIndex)),
            ),
            onTap: () {
              setState(() {
                this._playVideoSource(showIndex - 1,index);
              });
            }
          );
      },
    );

    return [listView];
  }

  Color _makeColor(bool isHighlightColor) {
    return  isHighlightColor ? Theme.of(context).highlightColor : Theme.of(context).textTheme.title.color;
  }

  Widget _buildName() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            videoModel?.list?.name ?? "",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            _getVideoYear(),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              videoModel?.getVideoInfo() ?? "",
              style: TextStyle(color: Colors.grey[200], fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "导演: ${videoModel?.list?.director ?? ""}",
              style: TextStyle(color: Colors.grey[200], fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "演员: ${videoModel?.list?.actor ?? ""}",
              style: TextStyle(color: Colors.grey[200], fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  String _getVideoYear() {
    String year = videoModel?.list?.year;
    if (year != null && year.isEmpty == false) {
      return "($year)";
    }
    return "";
  }

  Widget _buildDes() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "剧情简介",
              style: TextStyle(color: Colors.white, fontSize: 14),
              ),
          ),
          Container(
            child: Text(
              videoModel?.list?.des ?? "",
              style: TextStyle(color: Colors.grey[200], fontSize: 13),
            )
          ),
        ],
      ),
    );
  }


  void _playVideoSource(int sessionIndex, int index, { Duration position }) {

    var links2d = videoModel.getResourceVideoLinks();
    if (links2d.isEmpty) {
      return;
    }
    if (sessionIndex < 0 || sessionIndex >= links2d.length) {
      sessionIndex = 0;
    }

    playSessionIndex = sessionIndex;

    List<String> source = links2d[sessionIndex].map((item) => item.link).toList();

      player.playSession(
        source: source,
        index: index,
        position: position,
        errorCallback: (error) {
          Progresshud.showErrorWithStatus(error);
        }
      );
  }

  void _pageDispose() {
    _storeHistory(model: videoModel);
    player.dispose();
  }

  void _storeHistory({VideoModel model}) {

    var links2d = model?.getResourceVideoLinks() ?? [];

    if (model == null || links2d.isEmpty) {
      return;
    }

    if (playSessionIndex < 0 || playSessionIndex >= links2d.length) {
      playSessionIndex = 0;
    }

    List<VideoLink> videoLinkList = links2d[playSessionIndex];

    VideoListModel list = model.list;
    VideoLink link = videoLinkList[player.playIndex];

    Storage.addVideoHistory(StorageVideoHistory(
      id: list.id, 
      name: list.name, 
      position: player.fjPlayer.currentPos.inSeconds ?? 0, 
      duration: player.fjPlayer.value.duration.inSeconds ?? 0,
      pic: list.pic,
      sourceId: link.sourceId,
      sourceIndex: player.playIndex,
      sourceName: link.name
      ));
  }

  _requestDataSource() async {
    int id = widget.id ?? widget.history.id;
    String url = API_VIDEO_DETAIL + "/$id";
    HttpUtil.get(url, null)
      .then((result){
        setState(() {
          var model = VideoModel.fromJson(result.data);
          CacheModel.detailCache = model;
          this._requestSuccess(model);
        });
          
      }).catchError((onError){
        var error = onError.toString();
        var data = onError.response.data;
        if (data != null) {
          String message = data["info"];
          int code = data["code"];
          error = "error: $message $code";

          if (message.contains("登录") || code == 2) {
            _pushResetTokenPage();
          }
        }
        Progresshud.showErrorWithStatus(error);

      });
  }

  _requestSuccess(VideoModel model) {
    videoModel = model;
    int sessionIndex = 0;
    int index = 0;
    Duration position;  

    if (widget.history != null) {
      var links2d = videoModel.getResourceVideoLinks();
      for (var i = 0; i < links2d.length; i++) {
        /// 1 个数组 sourceid 相同
        if (links2d[i].first.sourceId == widget.history.sourceId) {
          sessionIndex = i;
          int historyPlayIndex = widget.history.sourceIndex;
          if (historyPlayIndex >= 0 && historyPlayIndex < links2d[i].length) {
            index = historyPlayIndex;
            position = widget.history.getDuration();
            break;
          }
        } 
      }
    }

    _playVideoSource(sessionIndex, index, position: position);
    setState(() {
      
    });
  }

  void _pushResetTokenPage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) {
        return ResetTokenPage();
      })
    );
  }
}