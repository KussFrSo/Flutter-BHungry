import 'package:bhungry/utilities/str_transformer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String uid;
  final String username;
  final String email;
  final String tipoUser;
  final String? webPage;
  final bool firstLogin;

  //Restaurante Vars
  final String? telefonos;
  // final String emailConsultas;
  final String? descripcion;
  final String? ubicacion;
  // final int valoracion;
  final List<String>? imagenesRest;
  final String? imagenes;
  final double? lat;
  final double? long;
  final List<String>? chats;
  // final List<String> categorias;

  //Users Vars
  // final Uint8List imgPerfil;
  //final List<String> filtros;
  final double? distanciaBuscadora;
  final List<String>? likedRest;

  final DateTime? lastMessageTime;

  User(
      {required this.uid,
      required this.username,
      required this.email,
      required this.tipoUser,
      required this.firstLogin,
      this.webPage,
      this.imagenes,
      this.descripcion,
      this.telefonos,
      this.ubicacion,
      this.lat,
      this.long,
      this.distanciaBuscadora,
      this.imagenesRest,
      this.likedRest,
      this.lastMessageTime,
      this.chats});

  Map<String, dynamic> toJSON() => {
        'uid': uid,
        'username': username,
        'email': email,
        'tipoUser': tipoUser,
        'firstLogin': firstLogin,
        'imagenes': imagenes,
        'descripcion': descripcion,
        'telefonos': telefonos,
        'ubicacion': ubicacion,
        'lat': lat,
        'long': long,
        'distanciaBuscadora': distanciaBuscadora,
        'imagenesRest': imagenesRest,
        'likedRest': likedRest,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
        'webPage': webPage,
        'chats': chats,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      tipoUser: snapshot['tipoUser'],
      firstLogin: snapshot['firstLogin'],
      imagenes: snapshot['imagenes'],
      descripcion: snapshot['descripcion'],
      telefonos: snapshot['telefonos'],
      ubicacion: snapshot['ubicacion'],
      lat: snapshot['lat'],
      long: snapshot['long'],
      distanciaBuscadora: snapshot['distanciaBuscadora'],
      imagenesRest:
          snapshot['imagenesRest'] != null && snapshot['imagenesRest'] != []
              ? snapshot['imagenesRest'].cast<String>()
              : [].cast<String>(),
      likedRest: snapshot['likedRest'] != null && snapshot['likedRest'] != []
          ? snapshot['likedRest'].cast<String>()
          : [].cast<String>(),
      lastMessageTime: Utils.toDateTime(snapshot['lastMessageTime']),
      webPage: snapshot['webPage'],
      chats: snapshot['chats'] != null && snapshot['chats'] != []
          ? snapshot['chats'].cast<String>()
          : [].cast<String>(),
    );
  }

  static User fromJson(Map<String, dynamic> snapshot) => User(
        username: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        tipoUser: snapshot['tipoUser'],
        firstLogin: snapshot['firstLogin'],
        imagenes: snapshot['imagenes'],
        descripcion: snapshot['descripcion'],
        telefonos: snapshot['telefonos'],
        ubicacion: snapshot['ubicacion'],
        lat: snapshot['lat'],
        long: snapshot['long'],
        distanciaBuscadora: snapshot['distanciaBuscadora'],
        imagenesRest:
            snapshot['imagenesRest'] != null && snapshot['imagenesRest'] != []
                ? snapshot['imagenesRest'].cast<String>()
                : [].cast<String>(),
        likedRest: snapshot['likedRest'] != null && snapshot['likedRest'] != []
            ? snapshot['likedRest'].cast<String>()
            : [].cast<String>(),
        lastMessageTime: Utils.toDateTime(snapshot['lastMessageTime']),
        webPage: snapshot['webPage'],
        chats: snapshot['chats'] != null && snapshot['chats'] != []
            ? snapshot['chats'].cast<String>()
            : [].cast<String>(),
      );
}
