import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showSnackBar(String missatge, BuildContext context, Color color) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(backgroundColor: color, content: Text(missatge)));
}

void showAlert(BuildContext context, String mensaje, String tittle) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(25))),
            title: Row(
              children: [
                Text(tittle),
                const SizedBox(
                  width: 15,
                ),
                const Icon(Icons.info)
              ],
            ),
            content: Text(mensaje),
          ));
}

pickImages() async {
  final ImagePicker _imagePicker = ImagePicker();
  List<Uint8List> arrImgs = [];

  List<XFile>? _file = await _imagePicker.pickMultiImage();

  if (_file != null) {
    for (var element in _file) {
      arrImgs.add(await element.readAsBytes());
    }
  }
  return arrImgs;
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return _file.readAsBytes();
  } else {}
}
