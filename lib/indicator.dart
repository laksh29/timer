import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.index,
    required this.activeIndex,
    required this.radius,
  });

  final int index;
  final int activeIndex;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: index == activeIndex ? Colors.white : Colors.white54,
      radius: radius,
    );
  }
}
