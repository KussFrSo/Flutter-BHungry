import 'package:flutter/material.dart';

class Event {
  final String titulo;
  final String hora;
  Event({required this.titulo, required this.hora});

  String toString() => this.titulo;
}
