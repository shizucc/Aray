import 'package:flutter/material.dart';

extension HexColor on Color {
  bool get isDark {
    double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance < 0.5;
  }
}

extension DarkenColorExtension on Color {
  Color darken(double factor) {
    factor = factor.clamp(0.0, 1.0);

    int red = (this.red * (1.0 - factor)).round();
    int green = (this.green * (1.0 - factor)).round();
    int blue = (this.blue * (1.0 - factor)).round();

    return Color.fromARGB(alpha, red, green, blue);
  }
}
