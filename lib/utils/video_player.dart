import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

import 'dart:async';

typedef PlayerErrorCallBack = void Function(String msg);
typedef PlayerAutoNextCallBack = void Function(int index);

class AppVideoPlayer {

  final FijkPlayer fjPlayer = FijkPlayer();

  /// 播放历史, 首次播放会从播放历史开始
  Duration _historyPosition;

  /// 资源列表
  List<String> sessionSource;

  /// 自动播放下一集时调用返回 index
  PlayerAutoNextCallBack autoNextAction;

  /// 当前播放 Index
  int playIndex;

  AppVideoPlayer() {
    fjPlayer.addListener(_playerListener);
  }

  /// 播放资源列表
  void playSession({List<String> source, int index, Duration position, PlayerErrorCallBack errorCallback}) {

    if (source == null || source.isEmpty) {
      print("AppVideoPlayer 资源为空");
      return;
    }

    sessionSource = source;
    if (playIndex != null && playIndex == index) {
      print("AppVideoPlayer 重复Index: $index");
      return;
    }

    bool isIndex = (index >= 0 && index < source.length);
    if (!isIndex) {
      print("AppVideoPlayer 资源数组越界: $index");
      return;
    }
    playIndex = index;

    // if (fjPlayer.state == FijkState.completed) {
    //   autoNextAction(index);
    // }

    String url = source[index];
    play(url: url, position: position, errorCallback: errorCallback);
  }

  void playerAutoNextAction(PlayerAutoNextCallBack autoNextAction) {
    autoNextAction = autoNextAction;
  }

  /// 播放
  void play({String url, Duration position, PlayerErrorCallBack errorCallback}) async {

    if (url == null || url.isEmpty) {
      errorCallback("资源错误, 请选择其它资源");
      return;
    }

    _historyPosition = position;

    if (fjPlayer.state == FijkState.idle) {

    } else {
      await fjPlayer.reset();
    }

    fjPlayer.setDataSource(url, autoPlay: true);
  }

  /// 销毁
  void dispose() {
    fjPlayer.removeListener(_playerListener);
    fjPlayer.release();
  }

  /// 构建播放器 Widget 
  Widget playerRatio({Color backgroudColor}) {
    return AspectRatio(
        aspectRatio: 1,
        child: FijkView(
          player: fjPlayer,
          color: backgroudColor,
          ),
    );
  }


  void _playerListener() {
    /// 首次播放如果包含历史记录, 从记录时间播放
    if (fjPlayer.value.prepared && _historyPosition != null) {
      fjPlayer.seekTo(_historyPosition.inMilliseconds);
    }
    /// 自动播放下一集  
    // if (fjPlayer.state == FijkState.completed && sessionSource != null) {
    //    playSession(source: sessionSource, index: playIndex + 1);   
    // }

  }

}
