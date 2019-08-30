
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vtape/models/history_video_model.dart';

class Storage {

  static const String PREF_VIDEOHISTORY = "PREF_VIDEOHISTORY";
  static const String PREF_TOKEN = "PREF_TOKEN";


  static addVideoHistory(StorageVideoHistory history) async {
    await videoHistory.then((value){
      // 最多 20 
      if (value.length >= 20) {
        value.removeLast();
      }
      // 去重
      var oldList = value;
      for (var item in value) {
        if (item.id == history.id) {
          oldList.remove(item);
          break;
        }
      }
      oldList.add(history);
      videoHistory = oldList;
    }).catchError((onError){
      print("缓存失败: $onError");
    });
  }

  static Future<List<StorageVideoHistory>> get videoHistory async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(PREF_VIDEOHISTORY) ?? [];
    return list.map((item) {
       final json = jsonDecode(item);
       return StorageVideoHistory.fromJson(json);
    }).toList() ?? [];
  }
  static set videoHistory(List<StorageVideoHistory> value){
    final list = value.map((item){
      return jsonEncode(item);
    }).toList();
    _setVideoHistory(list);
  }
  
  static _setVideoHistory(List<String> value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(PREF_VIDEOHISTORY, value);
  }

  static String cacheToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1Njg0NDc1MTgsImlkIjoxNDJ9.vlVVo0m1U6rup53dSlPEN_1ncSjukw9RtVIQznq3mjQ";

  static initCacheToken() {
    token.then((v){
      if (v.isEmpty == false) {
        cacheToken = v;
      }
    });
  }
  
  static Future<String> get token async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(PREF_TOKEN) ?? "";
    return token;
  }
  static set token(String value) {
    SharedPreferences.getInstance().then((pref) {
      cacheToken = value;
      pref.setString(PREF_TOKEN, value);
    });
  }

}

