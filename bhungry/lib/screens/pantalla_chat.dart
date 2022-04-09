import 'package:bhungry/models/users.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:bhungry/widgets/widgets_cards/chat_mensajes.dart';
import 'package:bhungry/widgets/widgets_cards/chat_nuevo_mensaje.dart';
import 'package:bhungry/widgets/widgets_cards/profile_header.dart';
import 'package:flutter/material.dart';

class PantallaChat extends StatefulWidget {
  const PantallaChat({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<PantallaChat> createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeader(user: widget.user),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: MensajesChat(user: widget.user),
              )),
              EnviarMesnaje(user: widget.user),
            ],
          ),
        ));
  }
}
