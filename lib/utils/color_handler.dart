import 'package:flutter/cupertino.dart';

class ColorHandler {
  static Color getColorFromDecimal(int decimal) {
    return Color(0xFFFFFFFF & decimal);
  }
}
