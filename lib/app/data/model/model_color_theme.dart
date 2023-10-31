import 'package:aray/utils/color_constants.dart';

class ColorTheme {
  String code;
  int? baseColor;
  int? primaryColor;

  ColorTheme({required this.code}) {
    final Map<String, int> colorData = ColorConstants.colors[code] ?? {};
    baseColor = colorData['base_color'];
    primaryColor = colorData['primary_color'];
  }
}
