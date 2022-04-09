import 'dart:math';
import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/providers/card_provider.dart';
import 'package:bhungry/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bhungry/models/card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class bhungrycard extends StatefulWidget {
  final CardRest objCard;
  final bool isFront;

  const bhungrycard({
    Key? key,
    required this.objCard,
    required this.isFront,
  }) : super(key: key);

  @override
  State<bhungrycard> createState() => _bhungrycardState();
}

class _bhungrycardState extends State<bhungrycard> {
  int _indexImg = 0;
  model.User? usr;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  void _incrementTab(index) {
    setState(() {
      _indexImg = index;
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: Stack(
                children: [
                  buildCard(),
                  buildStamps(),
                ],
              ),
            );
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTapUp: (TapUpDetails details) => tapImg(details),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              image: DecorationImage(
                image: NetworkImage(widget.objCard.urlImage[_indexImg]),
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
                  stops: [0.7, 1],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Spacer(),
                    buildName(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: 'Like', opacity: opacity);
        AuthMethods()
            .saveLikedRest(likedRest: widget.objCard.id, context: context);

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: 'Dislike', opacity: opacity);

        return Positioned(top: 64, right: 50, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: angle,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 4),
              ),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: color,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ))),
        ));
  }

  Widget buildName() => Column(
        children: [
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  child: Text(widget.objCard.nombre,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(widget.objCard.distancia,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ))
            ],
          )
        ],
      );

  tapImg(TapUpDetails details) {
    var x = details.globalPosition.dx;

    if (x >= 200) {
      setState(() {
        if (_indexImg < widget.objCard.urlImage.length - 1) _indexImg++;
      });
    } else {
      setState(() {
        if (_indexImg > 0) _indexImg--;
      });
    }
  }
}
