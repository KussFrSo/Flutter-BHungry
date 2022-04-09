import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class iconTextButton extends StatelessWidget {
  final IconData icono;
  final String text;
  final double borderRadius;
  final bool gradientInverted;
  final void Function() press;

  const iconTextButton({
    Key? key,
    required this.icono,
    required this.text,
    required this.borderRadius,
    required this.press,
    this.gradientInverted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
          gradient: gradientInverted ? gradientInv : gradient,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: ElevatedButton.icon(
        onPressed: press,
        icon: Icon(icono),
        label: Text(
          text,
          style: GoogleFonts.nunito(
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
      ),
    );
  }
}
