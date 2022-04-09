import 'package:bhungry/models/mensajes.dart';
import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/resources/firebase_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bhungry/widgets/widgets_cards/chat_mensaje.dart';
import 'package:google_fonts/google_fonts.dart';

class MensajesChat extends StatelessWidget {
  final model.User user;

  const MensajesChat({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Mensaje>>(
        stream: FirebaseChats.getMessages(user.tipoUser == "Restaurante"
            ? user.uid
            : FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Haz tu consulta a ' + user.username)
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return MensajeChat(
                              message: message,
                              img: user.tipoUser == "Restaurante"
                                  ? user.imagenesRest![0]
                                  : user.imagenes ??
                                      "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Pic.png",
                              isMe: message.username ==
                                  FirebaseAuth.instance.currentUser!.uid);
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: GoogleFonts.nunito(
              textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      );
}
