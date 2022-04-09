import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String carpeta, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(carpeta).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  Future<List<String>> uploadImageToStorages(
      String carpeta, List<Uint8List> file) async {
    List<String> arrImgs = [];
    for (var img in file) {
      String fileId = DateTime.now().toString();
      Reference ref = _storage
          .ref()
          .child(carpeta)
          .child(_auth.currentUser!.uid)
          .child(fileId);

      UploadTask uploadTask = ref.putData(img);
      TaskSnapshot snap = await uploadTask;
      String downloadURL = await snap.ref.getDownloadURL();
      arrImgs.add(downloadURL);
    }
    return arrImgs;
  }
}
