import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [primaryColor, secondaryColor],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
