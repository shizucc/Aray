import 'package:flutter/material.dart';

extension HexColor on Color {
  // String _generateAlpha({required int alpha, required bool withAlpha}) {
  //   if (withAlpha) {
  //     return alpha.toRadixString(16).padLeft(2, '0');
  //   } else {
  //     return '';
  //   }
  // }

  // String toHex({bool leadingHashSign = false, bool withAlpha = false}) =>
  //     '${leadingHashSign ? '#' : ''}0x${'${_generateAlpha(alpha: alpha, withAlpha: withAlpha)}'
  //         '${red.toRadixString(16).padLeft(2, '0')}'
  //         '${green.toRadixString(16).padLeft(2, '0')}'
  //         '${blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase()}';

  bool get isDark {
    double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance < 0.5;
  }
}
