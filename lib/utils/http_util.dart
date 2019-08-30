
import 'package:dio/dio.dart';
import 'storage.dart';

Options tapeOptions(String token) {
  return Options(
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    }
  );
}

class HttpUtil {


  static Future get(String url, Map<String, dynamic> params) async {
    Response response = await Dio(tapeOptions(Storage.cacheToken)).get(url, data: params);
    return response;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    Response response = await Dio(tapeOptions(Storage.cacheToken)).post(url, data: params);
    return response;
  }

}