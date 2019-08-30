

class RequestParams {

  // pid=&sort=1&area=&year=&source=&keyword=D&query=2&page=1&per_page=20

  /// 热门列表接口 1 电影 2 电视剧 3 综艺 4 动漫
  int pid; 

  /// 排序方式 1 默认
  int sort;

  /// 地区
  String area;

  /// 年份
  String year;

  String source;

  /// 搜索关键词
  String keyword;

  /// 匹配方式 1 精确 2 模糊
  String query;

  /// 当前页数
  int page;

  /// 一页请求总数
  int perPage;

  RequestParams({
    this.pid,
    this.sort,
    this.area,
    this.year,
    this.source,
    this.keyword,
    this.query,
    this.page,
    this.perPage
  });

  /// 视频类型初始化
  RequestParams.type(this.page, this.perPage);

  /// 视频搜索初始化
  RequestParams.search(this.keyword, this.page, this.perPage, {this.query = "2"});

  Map<String,dynamic> getParams() {
    Map<String,dynamic> params = {};
    params["pid"] = pid;
    params["sort"] = sort;
    params["area"] = area;
    params["year"] = year;
    params["source"] = source;
    params["keyword"] = keyword;
    params["query"] = query;
    params["page"] = page;
    params["per_page"] = perPage;
    return params;
  }
  
}