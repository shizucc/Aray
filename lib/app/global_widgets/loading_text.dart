import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingText extends StatelessWidget {
  const LoadingText({
    required this.labelText,
    this.labelTextStyle = const TextStyle(fontStyle: FontStyle.italic),
    super.key,
  });
  final String labelText;
  final TextStyle labelTextStyle;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade300,
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: labelTextStyle,
        ),
      ),
    );
  }
}
