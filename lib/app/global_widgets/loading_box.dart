import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class LoadingBox extends StatelessWidget {
  const LoadingBox(
      {super.key, this.height = -1, this.width = -1, this.borderRadius = 10});
  final double height;
  final double width;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    final bool isFullHeight = (height == -1);
    final bool isFullWidth = (width == -1);
    return SizedBox(
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(borderRadius)),
            width: isFullWidth ? MediaQuery.of(context).size.width : width,
            height: isFullHeight ? MediaQuery.of(context).size.height : height,
          )),
    );
  }
}
