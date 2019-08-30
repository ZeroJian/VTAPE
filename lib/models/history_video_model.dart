
class StorageVideoHistory {

  /// 视频 id
  int id;
  /// 名称
  String name;
  /// 播放进度(秒)
  int position;
  /// 总时长(秒)
  int duration;
  /// 封面
  String pic;
  /// 资源 id
  int sourceId;
  /// 资源播放集数
  int sourceIndex;
  /// 资源名称
  String sourceName;

  Duration getDuration() {
    if (position == 0) {
      return null;
    }
    return Duration(seconds: duration - 100);
  }

  String playTime() {
    Duration position = Duration(seconds: this.position);
    String p = position.toString().split(".").first ?? "-";
    Duration duration = Duration(seconds: this.duration);
    String d = duration.toString().split(".").first ?? "-";
    return "$p / $d";
  }


  StorageVideoHistory({
    this.id,
    this.name,
    this.position,
    this.duration,
    this.pic,
    this.sourceId,
    this.sourceIndex,
    this.sourceName
  });

  factory StorageVideoHistory.fromJson(Map<String, dynamic> jsonObj) {
    return StorageVideoHistory(
      id: jsonObj["id"],
      name: jsonObj["name"],
      position: jsonObj["position"],
      duration: jsonObj["duration"],
      pic: jsonObj["pic"],
      sourceId: jsonObj["sourceId"],
      sourceIndex: jsonObj["sourceIndex"],
      sourceName: jsonObj["sourceName"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "position": position,
      "duration": duration,
      "pic": pic,
      "sourceId": sourceId,
      "sourceIndex": sourceIndex,
      "sourceName": sourceName ?? ""
    };
  }

}