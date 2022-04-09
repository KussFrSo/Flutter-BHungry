import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LikedRestCard extends StatelessWidget {
  const LikedRestCard({Key? key, required this.rest}) : super(key: key);
  final rest;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(rest['imagenesRest'][0]),
            fit: BoxFit.cover,
            alignment: const Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 1],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                buildName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// https://stackoverflow.com/questions/44579918/flutter-wrap-text-on-overflow-like-insert-ellipsis-or-fade
  Widget buildName() => Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Text(rest['username'],
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        ],
      );
}
