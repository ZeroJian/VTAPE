import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ovprogresshud/progresshud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:vtape/utils/http_util.dart';
import 'package:vtape/pages/video_detail_page.dart';
import 'package:vtape/models/hot_list_model.dart';
import 'package:vtape/models/request_params.dart';

class VideoListWidget extends StatefulWidget {
  
  VideoListWidget({
    this.parentContext, 
    this.url, 
    this.initialRefresh, 
    this.paramsCallback, 
    Key key}) : super(key: key);


  static VideoListWidget typeList({BuildContext context, String url}) {
    return VideoListWidget(
        parentContext: context,
        url: url, 
        initialRefresh: true,
        paramsCallback: (page){ 
          var type = RequestParams.type(page, 20);
          return type.getParams();
        } 
    );
  }

  static VideoListWidget hot({BuildContext context, String url}){
    return VideoListWidget(
        parentContext: context,
        url: url, 
        initialRefresh: true,
        paramsCallback: (page){ 
          Map<String, dynamic> params = {"pid":page};
          return params;
        } 
    );
  }

  Map<String, dynamic> Function(int page) paramsCallback;

  String url;

  bool initialRefresh = false;

  BuildContext parentContext;

  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> with AutomaticKeepAliveClientMixin {

  int currentPage = 1;
  int pageSize = 20;
  RefreshController refreshController;

  List<VideoListModel> dataSource = [];


  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: widget.initialRefresh);
  }

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var gridView = GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 3,
                childAspectRatio: 0.5
              ),
              addRepaintBoundaries: false,

              padding: EdgeInsets.all(12),
              itemCount: dataSource.length,
              itemBuilder: (context, index){
                return _makeCard(dataSource[index]);
              },
            );
    var refresh = SmartRefresher(
      enablePullDown: true,
      enablePullUp: currentPage != 1,
      header: WaterDropHeader(),
      footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("加载更多", style: TextStyle(color: Colors.white),);
            }
            else if(mode==LoadStatus.loading){
              // body = CupertinoActivityIndicator();
              body = CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("加载失败！点击重试！");
            }
            else{
              body = Text("没有更多数据了!");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: refreshController,
        onRefresh: () => requestDataSource(1),
        onLoading: () => requestDataSource(currentPage),
        child: gridView,
    );

    return refresh;
  }

  Widget _makeCard(VideoListModel model) {
       var container = Container(
            // color: Theme.of(widget.parentContext).scaffoldBackgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 13,
                  child: Container(
                    color: Theme.of(widget.parentContext).backgroundColor,
                    child: CachedNetworkImage(
                      imageUrl: model.pic ?? "",
                      placeholder: (context, url) {
                        return Center(
                          child: Image.asset(
                            "images/logo_min200.png",
                            width: 30,
                            ),
                        );
                      },
                      width: 1000,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                          Text(  
                            model.name + "                          ",
                            // textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Theme.of(widget.parentContext).textTheme.title.color,
                              fontSize: 14
                              ),
                            maxLines: 1,
                            // softWrap: true,
                            overflow: TextOverflow.ellipsis
                          ),
                        // ],
                      // ),
                      Text(
                        model.area,
                        style: TextStyle(
                          color: Theme.of(widget.parentContext).textTheme.subtitle.color,
                          fontSize: 10,
                          ),
                        maxLines: 1,
                      )
                  ]
                    ),
                  ),
                )
              ],
            ),
          );

    return Card(
      color: Theme.of(widget.parentContext).scaffoldBackgroundColor,
      child: GestureDetector(
        onTap: () => _cardTaped(model),
        behavior: HitTestBehavior.opaque,
        child: container,
      ),
    );
  }

  _cardTaped(VideoListModel model) {
    int id =  model.id;
    print("当前 id $id");

    Navigator.push(
      widget.parentContext, 
      MaterialPageRoute(builder: (context) {
        return VideoDetailPage(id: model.id,);
      })
    );
  }

  requestDataSource(int page) async {
    currentPage = page;
    var params = widget.paramsCallback(page);

    HttpUtil.get(widget.url, params)
      .then((result) {
        if (result.statusCode != 200) {
           this._requestError(page, "数据异常");
           return;
        } 
            List<VideoListModel> tempList = [];
            for(int i = 0; i < result.data.length; i++) {
              VideoListModel model = VideoListModel.fromJson(result.data[i]);
              tempList.add(model);
            }
            CacheModel.listCache = tempList;
            this._requestSuccess(tempList, page);
            
      }).catchError((onError){
        var error = onError.toString();
        var data = onError.response.data;
        if (data != null) {
          String message = data["info"];
          int code = data["code"];
          error = "error: $message $code";
        }
        this._requestError(page, error);
      });
  }

  _requestSuccess(List<VideoListModel> list, int page) {

    print("当前page: $page");
    if (page == 1) {
      dataSource = [];
    }
    dataSource.addAll(list);
    currentPage += 1;
    setState(() {});
    if (page == 1) {
      refreshController.refreshCompleted();
    } else {
      if (list.length < 20) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  _requestError(int page, String error) {
    if (page == 1) {
      this.refreshController.refreshFailed();
    }  else {
      this.refreshController.loadFailed();
    }
    print("连接失败");
    Progresshud.showErrorWithStatus(error);
  }
}

