import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class registerInput extends StatelessWidget {
  final String placeholder;
  final String title;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool isPass;
  final int? numLineas;
  final String initValue;

  const registerInput({
    Key? key,
    required this.placeholder,
    required this.title,
    required this.textEditingController,
    required this.textInputType,
    this.isPass = false,
    this.numLineas = 1,
    this.initValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff898989))),
          ),
          TextField(
            controller: textEditingController..text = initValue,
            maxLines: numLineas,
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff2C2C2C))),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2C2C2C))),
            ),
            keyboardType: textInputType,
            obscureText: isPass,
          )
        ],
      ),
    );
  }
}
