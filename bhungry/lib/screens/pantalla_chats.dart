import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/resources/firebase_chats.dart';
import 'package:bhungry/widgets/widgets_cards/chat_body.dart';
import 'package:bhungry/widgets/widgets_cards/chat_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PantallaChats extends StatefulWidget {
  PantallaChats({Key? key}) : super(key: key);

  @override
  State<PantallaChats> createState() => _PantallaChatsState();
}

class _PantallaChatsState extends State<PantallaChats> {
  bool isLoading = false;
  List<dynamic> listUser = [];
  String tipoUser = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      tipoUser = userSnap.data()!['tipoUser'];

      if (tipoUser == "Restaurante") {
        listUser = userSnap.data()!['chats'];
      } else {
        listUser = userSnap.data()!['likedRest'];
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chats",
          style: GoogleFonts.nunito(
              textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: StreamBuilder<List<model.User>>(
                stream: FirebaseChats.getUsers(listUser),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("ERROR"),
                        );
                      } else {
                        final users = snapshot.data;

                        if (users!.isEmpty) {
                          return const Center(
                            child: Text(
                                "No se han encontrado restaurantes guardados!"),
                          );
                        } else {
                          return Column(children: [
                            ChatHeader(
                              users: users,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ChatBody(users: users),
                          ]);
                        }
                      }
                  }
                },
              ),
            ),
    );
  }
}
