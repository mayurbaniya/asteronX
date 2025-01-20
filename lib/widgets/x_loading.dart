import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoadingIndicator({
    super.key,
    required this.color,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: size,
          height: size,
          child: SpinKitWave(
            color: color,
            size: size,
          )),
    );
  }
}
