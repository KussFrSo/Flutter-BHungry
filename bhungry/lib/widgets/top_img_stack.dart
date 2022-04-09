import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class topImgLogIn extends StatelessWidget {
  topImgLogIn(
      {Key? key,
      required this.url,
      required this.title,
      required this.secondTitle})
      : super(key: key);

  String url;
  String title, secondTitle;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(url),
        Positioned(
            top: 120,
            child: Container(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                children: [
                  Text(title + "\n" + secondTitle,
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 46,
                              fontWeight: FontWeight.w900))),
                ],
              ),
            ))
      ],
    );
  }
}
