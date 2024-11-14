import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final double? value;
  const LoadingPage({
    super.key,
    this.size = 16,
    this.strokeWidth = 1,
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
