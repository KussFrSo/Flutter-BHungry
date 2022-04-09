import 'package:bhungry/models/mensajes.dart';
import 'package:bhungry/utilities/str_transformer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bhungry/models/users.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseChats {
  static Stream<List<model.User>> getUsers(likedRest) =>
      FirebaseFirestore.instance
          .collection('users')
          .where("uid", whereIn: likedRest)
          .snapshots()
          .transform(Utils.transformer(model.User.fromJson));

  static Future uploadMessage(model.User user, String message) async {
    final uid;
    String imagePerfil = "";
    if (user.tipoUser == "Restaurante") {
      uid = user.uid;
      imagePerfil = user.imagenesRest![0];
    } else {
      uid = FirebaseAuth.instance.currentUser!.uid;
      imagePerfil = user.imagenes ??
          "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Pic.png";
    }

    final refMessages =
        FirebaseFirestore.instance.collection('chats/$uid/messages');

    final newMessage = Mensaje(
      uid: user.uid,
      imgPerfil: imagePerfil,
      username: FirebaseAuth.instance.currentUser!.uid,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(uid)
        .update({model.UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Mensaje>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MensajeField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Mensaje.fromJson));

  static Future updateRestChats(model.User user) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (user.tipoUser == "Restaurante") {
      Stream<List<model.User>> rest = FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: user.uid)
          .snapshots()
          .transform(Utils.transformer(model.User.fromJson));

      if (!user.chats!.contains(FirebaseAuth.instance.currentUser!.uid)) {
        List<String> chats = user.chats!;
        chats.add(FirebaseAuth.instance.currentUser!.uid);
        _firestore.collection("users").doc(user.uid).update({"chats": chats});
      }
    }
  }
}

// .orderBy(UserField.lastMessageTime, descending: true)