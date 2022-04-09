import 'package:bhungry/models/users.dart';
import 'package:bhungry/screens/pantalla_chat.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    users.length.toString() + " Chats",
                    style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
            Expanded(child: Container(child: buildChats())),
          ],
        ),
      ),
    );
  }

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
              height: 75,
              child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PantallaChat(
                            user: user,
                          ))),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: user.tipoUser == 'Restaurante'
                        ? NetworkImage(user.imagenesRest![0])
                        : NetworkImage(user.imagenes ??
                            "https://www.pngmart.com/files/21/Account-Avatar-Profile-PNG-Pic.png"),
                  ),
                  title: Text(
                    user.username,
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  subtitle: Text(
                    user.ubicacion ?? "N/A",
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    onPressed: () => callRest(user.telefonos),
                  )));
        },
      );

  void callRest(telephon) async {
    await launch("tel://" + telephon);
  }
}
