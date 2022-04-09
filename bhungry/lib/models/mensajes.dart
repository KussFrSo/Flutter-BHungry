import 'package:bhungry/utilities/str_transformer.dart';
import 'package:flutter/material.dart';

class MensajeField {
  static final String createdAt = 'createdAt';
}

class Mensaje {
  final String uid;
  final String imgPerfil;
  final String username;
  final String message;
  final DateTime? createdAt;

  const Mensaje({
    required this.uid,
    required this.imgPerfil,
    required this.username,
    required this.message,
    this.createdAt,
  });

  static Mensaje fromJson(Map<String, dynamic> json) => Mensaje(
        uid: json['uid'],
        imgPerfil: json['imgPerfil'],
        username: json['username'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'imgPerfil': imgPerfil,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
