import 'dart:typed_data';

import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/providers/user_providers.dart';
import 'package:bhungry/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Registrar-se PHASE 1
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String tipoUser,
  }) async {
    String res = "Ha ocurrido un error";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          tipoUser.isNotEmpty) {
        //Registrem el usuari

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //Afeguim el usuari a la base de dades

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          tipoUser: tipoUser,
          firstLogin: false,
        );

        _firestore.collection("users").doc(cred.user!.uid).set(user.toJSON());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Inicia Sessio
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Ha ocurrido un error";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Porfavor rellena todos los campos!";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> updateRest(
      {required String email,
      required String username,
      String? descripcion,
      String? telefono,
      String? ubicacion,
      String? webPage,
      List<Uint8List>? imgs,
      double? lat,
      double? long,
      required model.User userInfo,
      required context}) async {
    String res = "Ha ocurrido un erro!";
    List<String> imagenesRest = [];
    try {
      if (email.isNotEmpty || username.isNotEmpty) {
        String photoURL;
        if (imgs != null) {
          imagenesRest = await StorageMethods()
              .uploadImageToStorages('restaurantImages', imgs);
        }

        model.User user = model.User(
            uid: userInfo.uid,
            tipoUser: userInfo.tipoUser,
            username: username,
            email: email,
            firstLogin: true,
            descripcion: descripcion,
            telefonos: telefono,
            ubicacion: ubicacion,
            webPage: webPage,
            imagenesRest: imagenesRest,
            lat: lat ?? userInfo.lat,
            long: long ?? userInfo.long);

        _firestore.collection("users").doc(userInfo.uid).update(user.toJSON());

        res = "success";
      } else {
        res = "Rellene los campos!";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> updateUser(
      {required String email,
      required String username,
      String? telefono,
      Uint8List? img,
      double? distanciaBuscadora,
      required model.User userInfo,
      required context}) async {
    String res = "Ha ocurrido un erro!";

    try {
      if (email.isNotEmpty || username.isNotEmpty) {
        String? photoURL;
        if (img != null) {
          photoURL = await StorageMethods()
              .uploadImageToStorage('userImages', img, false);
        }

        model.User user = model.User(
            uid: userInfo.uid,
            tipoUser: userInfo.tipoUser,
            username: username,
            email: email,
            firstLogin: true,
            telefonos: telefono,
            imagenes: photoURL ?? userInfo.imagenes,
            distanciaBuscadora: distanciaBuscadora,
            likedRest: userInfo.likedRest);

        _firestore.collection("users").doc(userInfo.uid).update(user.toJSON());

        res = "success";
      } else {
        res = "Rellene los campos!";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> saveLikedRest(
      {required String likedRest, required context}) async {
    String res = "Ha ocurrido un erro!";
    List<String> arrLikedRest = [];
    bool isLiked = false;
    model.User userInfo;

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userInfo = model.User.fromSnap(userSnap);

      arrLikedRest = userInfo.likedRest!;

      for (var liked in arrLikedRest) {
        if (liked == likedRest) {
          isLiked = true;
        }
      }

      if (!isLiked) {
        arrLikedRest.add(likedRest);

        model.User user = model.User(
            uid: userInfo.uid,
            tipoUser: userInfo.tipoUser,
            username: userInfo.username,
            email: userInfo.email,
            firstLogin: userInfo.firstLogin,
            likedRest: arrLikedRest,
            distanciaBuscadora: userInfo.distanciaBuscadora);

        _firestore.collection("users").doc(userInfo.uid).update(user.toJSON());
        addData(context);
        res = "success";
      }
      res = "Ya esta guardado este restaurante";
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  void addData(context) async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
