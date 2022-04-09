import 'package:bhungry/models/users.dart';
import 'package:bhungry/screens/pantalla_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (index == 0) {
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          child: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 24,
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PantallaChat(
                                            user: user,
                                          ))),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: user.tipoUser == 'Restaurante'
                                    ? NetworkImage(user.imagenesRest![0])
                                    : NetworkImage(user.imagenes ??
                                        "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Pic.png"),
                              ),
                            ))
                      ],
                    );
                  } else {
                    return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PantallaChat(
                                        user: user,
                                      ))),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: user.tipoUser == 'Restaurante'
                                ? NetworkImage(user.imagenesRest![0])
                                : NetworkImage(user.imagenes ??
                                    "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Pic.png"),
                          ),
                        ));
                  }
                }),
          )
        ],
      ),
    );
  }
}
