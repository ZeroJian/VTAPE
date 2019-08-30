
import 'package:flutter/foundation.dart';


class CacheModel {

  static List<VideoListModel> listCache = [];
  static Map<String, List<VideoListModel>> listMapCache = {};

  static VideoModel detailCache;

  static bool isUseCache = true;

}

class VideoListModel {

  // "id": 59358,
  //       "created_at": "2019-08-04T17:05:35+08:00",
  //       "updated_at": "2019-08-16T23:10:37+08:00",
  //       "deleted_at": null,
  //       "name": "烈火英雄",
  //       "pic": "http://www.605zy.cc/upload/vod/2019-08/15649784381.jpg",
  //       "actor": "黄晓明,杜江,谭卓,杨紫,欧豪,侯勇,刘金山,丁嘉丽,张哲瀚,谷嘉诚,印小天,高戈",
  //       "director": "陈国辉",
  //       "area": "大陆",
  //       "lang": "国语",
  //       "des": "一场滨海城市石油码头的管道爆炸，牵连了整个原油储存区，一座储油量高达10万立方米的储油罐已经爆炸并且泄露，泄露的原油随时可能引爆临近的油罐，火灾不断升级，爆炸接连发生，然而这还都不是最恐怖的，火场不远处伫立的危险化学物储藏区，像跃跃欲试的魔鬼等待着被点燃，刹那便能带走几百万人的生命，威胁全市、全省，甚至邻国的安全。在这样的危难时刻，一批批消防队员告别家人，赶赴火场 。",
  //       "year": "2019",
  //       "views": 34,
  //       "pid": 10,
  //       "label": {
  //           "name": "",
  //           "pid": null,
  //           "show": false
  //       }

  int id;
  String created;
  String name;
  String pic;
  String actor;
  String director;
  String area;
  String lang;
  String des;
  String year;
  int views;
  int pid;

  VideoListModel({
    this.id,
    this.created,
    this.name,
    this.pic,
    this.actor,
    this.director,
    this.area,
    this.lang,
    this.des,
    this.year,
    this.views,
    this.pid
    });

  factory VideoListModel.fromJson(Map<String, dynamic> jsonObj) {
    return VideoListModel(
      id: jsonObj["id"],
      created: jsonObj["created_at"],
      name: jsonObj["name"] ?? "",
      pic: jsonObj["pic"] ?? "",
      actor: jsonObj["actor"],
      director: jsonObj["director"],
      area: jsonObj["area"],
      lang: jsonObj["lang"],
      des: jsonObj["des"],
      year: jsonObj["year"],
      views: jsonObj["views"],
      pid: jsonObj["pid"]
    );
  }


}

class VideoModel {

  VideoListModel list;
  List<VideoResource> resource;
  VideoLabel label;

  VideoModel({
    this.list,
    this.resource,
    this.label
  });

  /// 资源2d列表
  List<List<VideoLink>> getResourceVideoLinks() {
    List<List<VideoLink>> links2d = [];
    for (var item in resource) {
      List<VideoLink>links = item.getVideoLinks();
      if (links.isEmpty) {
        continue;
      }
      // 默认使用一个数组, 电视剧使用 2d 数组
      if (label.pid != 2 && links2d.isEmpty == false) {
        links2d.first.addAll(links);
        continue;
      }

      links2d.add(links);
    }
    return links2d;
  }

  /// 地区/类型/语言
  String getVideoInfo() {
    String info = "";
    String area = list?.area;
    if (area != null && area.isEmpty == false) {
      info += list.area;
    }
    String type = label?.name;
    if (type != null && type.isEmpty == false) {
      if (info.isEmpty == false) {
        info += " / ";
      }
      info += type; 
    }
    String lang = list?.lang;
    if (lang != null && lang.isEmpty == false) {
      if (info.isEmpty == false) {
        info += " / ";
      }
      info += lang;
    }
    return info;
  }


  factory VideoModel.fromJson(Map<String, dynamic> jsonObj) {

    List<dynamic> r = jsonObj["resources"];
    return VideoModel(
      list: VideoListModel.fromJson(jsonObj),
      resource: r.map((item) => VideoResource.fromJson(item)).toList(),
      label: VideoLabel.fromJson(jsonObj["label"])
    );
  }
}

class VideoResource {

  // "id": 76221,
            // "created_at": "2019-08-07T01:05:34+08:00",
            // "updated_at": "2019-08-07T21:06:00+08:00",
            // "deleted_at": null,
            // "links": 
            // 第01集$https://yanzishan.shuhu-zuida.com/20190828/15170_b9c98296/index.m3u8$zuidam3u8
            // # 第02集$https://yanzishan.shuhu-zuida.com/20190828/15169_799f67f3/index.m3u8$zuidam3u8
            // # 第03集$https://yanzishan.shuhu-zuida.com/20190828/15168_e6263fbf/index.m3u8$zuidam3u8
            // "source": "zdziyuan",
            // "pid": 59509
  int id;
  String source;
  /// 一个资源组可以有多资源 使用 $ 分割, 比如剧集 
  String links;

  VideoResource({
    this.id,
    this.source,
    this.links
  });

  /// 获取视频资源列表
  List<VideoLink> getVideoLinks() {
    if (links == null || links.isEmpty) {
      return [];
    }
    /// 每集 # 隔开
     List<String>s = links.split("#");
     if (s.isEmpty) {
       return [];
     }
     List<VideoLink> vlinkList = [];
     
     for (var i = 0; i < s.length; i++) {
       // 单集内容通过 $ 隔开
       List<String> vsplit = s[i].split("\$");
       if (vsplit.isEmpty) {
         continue;
       }
       for (var j = 0; j < vsplit.length; j++) {
          String v = vsplit[j];
          if (v.startsWith("http")) {
              VideoLink vlink = VideoLink();
              vlink.link = v;
              /// 资源地址前必定是资源名称
              String name = j == 0 ? "资源A" : vsplit[j-1];
              vlink.name = name;
              // 一个数组 sourceid 相同
              vlink.sourceId = id;
              vlinkList.add(vlink);
          }
       }
     }
     return vlinkList;
  }

  factory VideoResource.fromJson(Map<String, dynamic> jsonObj) {
    return VideoResource(
      id: jsonObj["id"],
      source: jsonObj["source"],
      links: jsonObj["links"]
    );
  }

}



class VideoLabel {

  //  "label": {
  //       "id": 10,
  //       "created_at": "2019-05-12T16:25:11+08:00",
  //       "updated_at": "2019-08-20T15:26:08+08:00",
  //       "deleted_at": null,
  //       "name": "剧情片",
  //       "pid": 1,
  //       "show": true
  //   },
  int id;
  /// 类型
  String name;
  
  /// 1 电影 2 电视剧 3 综艺 4 动漫
  int pid;

  bool show;

  VideoLabel({
    this.id,
    this.name,
    this.pid,
    this.show
  });

  factory VideoLabel.fromJson(Map<String, dynamic> jsonObj) {
    return VideoLabel(
      id: jsonObj["id"],
      name: jsonObj["name"],
      pid: jsonObj["pid"],
      show: jsonObj["show"]
    );
  }

}


class VideoLink {

    String name;
    String link;
    int sourceId;

    VideoLink({
      this.name,
      this.link,
      this.sourceId
    });
}