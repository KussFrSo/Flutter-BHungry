import 'package:bhungry/widgets/gradienticon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonGradientIcon extends StatelessWidget {
  final IconData? icono;
  final void Function() press;

  const ButtonGradientIcon({Key? key, this.icono, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0.0,
      ),
      child: RadiantGradientMask(
          child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 9.0),
              child: Icon(icono, size: 25, color: Colors.white))),
    );
  }
}
