import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile?> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 88,
  );

  // print(file.lengthSync());
  // print(result?.lengthSync());

  return result;
}
