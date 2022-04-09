import 'dart:io';

import 'package:bhungry/providers/user_providers.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:bhungry/widgets/bio.dart';
import 'package:bhungry/widgets/likedRest_card.dart';
import 'package:bhungry/widgets/qr_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bhungry/models/users.dart' as model;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PantallaLikedRest extends StatefulWidget {
  const PantallaLikedRest({Key? key}) : super(key: key);

  @override
  State<PantallaLikedRest> createState() => _PantallaLikedRestState();
}

class _PantallaLikedRestState extends State<PantallaLikedRest> {
  bool _loading = false;
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: const BoxDecoration(
        gradient: gradientvertical,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchString = value.toLowerCase();
                            });
                          },
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Search',
                              suffixIcon: IconButton(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => QRScanner())),
                                icon: const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Colors.white,
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: searchString.isEmpty
                    ? FirebaseFirestore.instance
                        .collection("users")
                        .where("uid", whereIn: user.likedRest)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("users")
                        .where("uid", whereIn: user.likedRest)
                        .orderBy('username')
                        .startAt([searchString]).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      return Container(
                          child: GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3,
                                      crossAxisSpacing: 10),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: index % 2 == 0
                                        ? const EdgeInsets.only(
                                            left: 20.0, top: 20)
                                        : const EdgeInsets.only(
                                            right: 20.0, top: 20),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => BioRest(
                                                    rest: model.User.fromSnap(
                                                        snapshot.data!
                                                            .docs[index]))));
                                      },
                                      child: Hero(
                                        tag: snapshot.data!.docs[index]['uid'],
                                        child: LikedRestCard(
                                            rest: snapshot.data!.docs[index]
                                                .data()),
                                      ),
                                    ),
                                  )));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    }
                  }
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// https://stackoverflow.com/questions/60797422/flutter-app-grid-view-with-search-filter
