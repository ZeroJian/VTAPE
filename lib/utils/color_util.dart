
import 'package:flutter/material.dart';

class VtapeColor {

  static Color hexToColor(String s) {
  // 如果传入的十六进制颜色值不符合要求，返回默认值
    if (s == null || s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }


  static final Color foreground = hexToColor("#112233");

  static final Color foregroundLight = hexToColor("#354151");

  static final Color back = hexToColor("#050a17");

  static final Color title = Colors.white;

  static final Color subTitle = hexToColor("#666666");

  static final Color highlight = hexToColor("#dd6f55");



}