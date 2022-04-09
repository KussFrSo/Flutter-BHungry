import 'dart:async';

import 'package:bhungry/models/card.dart';
import 'package:bhungry/providers/card_provider.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bhungry/widgets/bhungrycard.dart';

class PricipalHome extends StatefulWidget {
  const PricipalHome({Key? key}) : super(key: key);

  @override
  State<PricipalHome> createState() => _PricipalHomeState();
}

class _PricipalHomeState extends State<PricipalHome> {
  Position? actualPosition;
  String mensajeSinFotos = "Se estan cargando mas restaurantes...";
  bool ubiLoaded = false;
  Timer? _timer;
  int _start = 10;
  bool showLoading = true;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            mensajeSinFotos =
                "No se han encontrado mas restaurantes, pruebe mas tarde!";
            showLoading = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: gradientvertical,
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        buildEncuentra(),
                        const SizedBox(height: 10),
                        Expanded(
                          child: buildCards(),
                        ),
                        const SizedBox(height: 30),
                      ],
                    )))));
  }

  Widget buildEncuentra() => Row(
        children: [
          const SizedBox(width: 4),
          Text('Encuentra',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              )),
        ],
      );

  Widget buildCards() {
    List<CardRest> objCards = Provider.of<CardProvider>(context).getObjCards;

    return objCards.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: showLoading
                        ? const CircularProgressIndicator()
                        : Container()),
                Text(
                  mensajeSinFotos,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              ],
            ),
          )
        : Stack(
            children: objCards
                .map<Widget>((urlImage) => bhungrycard(
                      objCard: urlImage,
                      isFront: objCards.last == urlImage,
                    ))
                .toList(),
          );
  }
}
