import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Themed spinner — defaults to ColorScheme.primary if no color provided.
class CustomLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const CustomLoadingIndicator({
    super.key,
    this.color,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: SpinKitWave(color: c, size: size),
      ),
    );
  }
}
