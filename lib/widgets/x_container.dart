import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReusableContainer extends StatelessWidget {
  final double radius;
  final Widget child;

  const ReusableContainer({
    super.key,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Container(
        width: Get.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(child: child),
      ),
    );
  }
}
