import 'package:flutter/material.dart';

class tittleWithUnderline extends StatelessWidget {
  const tittleWithUnderline(
      {Key? key,
      required this.textHint,
      required this.press,
      required this.underlineColor})
      : super(key: key);

  final String textHint;
  final void Function() press;
  final Color underlineColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(right: 20 / 4),
              height: 7,
              color: underlineColor,
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: press,
              child: Text(
                textHint,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
