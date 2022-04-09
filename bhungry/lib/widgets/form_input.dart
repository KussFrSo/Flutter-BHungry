import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const FormInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      controller: textEditingController,
      style: GoogleFonts.nunito(
        textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Color(0xFF3C3C3C)),
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23.0),
          borderSide: const BorderSide(
            color: inputForm,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23.0),
          borderSide: const BorderSide(
            color: inputForm,
          ),
        ),
        hintText: hintText,
        filled: true,
        hintStyle: const TextStyle(color: Color(0xFF3C3C3C)),
        fillColor: inputForm,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25.0, horizontal: 30),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
