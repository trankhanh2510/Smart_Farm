import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final double? value;
  const CircularProgress({
    super.key,
    this.size = 16,
    this.strokeWidth = 5,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          value: value,
        ),
      ),
    );
  }
}

class LinearProgressApp extends StatelessWidget {
  final double height;
  final double width;
  const LinearProgressApp({
    super.key,
    this.height = 10,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: const LinearProgressIndicator(),
      ),
    );
  }
}
