import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownInput extends StatefulWidget {
  String placeholder;
  Function(String) callback;
  DropdownInput({Key? key, required this.callback, required this.placeholder})
      : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInput();
}

class _DropdownInput extends State<DropdownInput> {
  var items = ["Usuario", "Restaurante"];
  String? msg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
          color: inputForm,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: inputForm)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(
            widget.placeholder,
            style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Color(0xFF3C3C3C))),
          ),
          value: msg,
          items: items.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            widget.callback(value as String);
            msg = value;
          }),
          isExpanded: true,
          iconSize: 36,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Color(0xFF3C3C3C)),
          ),
        ),
      );
}
