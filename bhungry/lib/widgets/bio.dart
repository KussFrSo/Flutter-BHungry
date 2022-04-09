import 'package:bhungry/models/users.dart';
import 'package:bhungry/screens/pantalla_chat.dart';
import 'package:bhungry/widgets/custom_rounded_button.dart';
import 'package:bhungry/widgets/gallery.dart';
import 'package:bhungry/widgets/google_mapa.dart';
import 'package:bhungry/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class BioRest extends StatefulWidget {
  BioRest({Key? key, required this.rest}) : super(key: key);
  User rest;

  @override
  State<BioRest> createState() => _BioRestState();
}

class _BioRestState extends State<BioRest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.rest.username,
            style: GoogleFonts.nunito(
                textStyle: TextStyle(fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.amber,
        ),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0, //remove elevetion
                  backgroundColor:
                      Colors.white, // match the color of sliver grid/list
                  leading: SizedBox(), // // hide arrow icon
                  leadingWidth: 0.0, // hide arrow icon
                  expandedHeight: 200,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode:
                        CollapseMode.pin, // to make radius remain if scrolled
                    title: Text(
                      widget.rest.username,
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    titlePadding: EdgeInsets.all(30),
                    centerTitle: true,
                    stretchModes: [
                      StretchMode.zoomBackground, // zoom effect
                      StretchMode.fadeTitle, // fade effect
                    ],
                    background: Container(
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand, // expand stack
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.srcOver,
                            ),
                            child: Container(
                              child: Image.network(
                                widget.rest.imagenesRest![0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(50),
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0,
                                  )),
                            ),
                            bottom: -1,
                            left: 0,
                            right: 0,
                          ),
                          Positioned(
                            bottom: 0, // to bottom
                            right: 45, // to right 45
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: InkWell(
                                onTap: (() => goToChat(widget.rest)),
                                child: Container(
                                  color: Colors.amber,
                                  width: 60,
                                  height: 60,
                                  child: const Icon(
                                    Icons.chat,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                      color: Colors.white,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Puntuación",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        const rating(),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(children: [
                          const Icon(
                            Icons.computer,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                widget.rest.webPage ?? "Sin información",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(fontSize: 15)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          const Icon(
                            Icons.email,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                widget.rest.email,
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(fontSize: 15)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.amber,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                  widget.rest.telefonos ?? "Sin información",
                                  style: GoogleFonts.nunito(
                                      textStyle: TextStyle(fontSize: 15)),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 150,
                          padding: EdgeInsets.all(16).copyWith(left: 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.pin_drop_outlined,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.rest.ubicacion ??
                                          "Sin información",
                                      style: GoogleFonts.nunito(
                                          textStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 115,
                                          width: 100,
                                          child: GestureDetector(
                                            onTap: () => goToMaps(
                                                widget.rest.lat ?? 0.0,
                                                widget.rest.long ?? 0.0),
                                            child: AbsorbPointer(
                                              child: UbiRest(
                                                  lat: widget.rest.lat,
                                                  lng: widget.rest.long,
                                                  username:
                                                      widget.rest.username),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 4),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: ReadMoreText(
                                widget.rest.descripcion ?? "",
                                trimLines: 3,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "Leer Mas",
                                trimExpandedText: "Leer Menos",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Galeria",
                              style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.rest.imagenesRest!.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 270,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => openGalery(index),
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.network(
                                      widget.rest.imagenesRest![index],
                                    )),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            iconTextButton(
                                icono: Icons.web,
                                text: "Web",
                                borderRadius: 20,
                                press: () => showWebPage(widget.rest.webPage)),
                            iconTextButton(
                              icono: Icons.call,
                              text: "Llamar",
                              borderRadius: 20,
                              press: () => callRest(widget.rest.telefonos),
                            )
                          ],
                        )
                      ]))),
            )));
  }

  void openGalery(index) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => GalleryViewer(
              images: widget.rest.imagenesRest,
              index: index,
            )));
  }

  static Future<void> goToMaps(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void showWebPage(webPage) async {
    await launch(webPage);
  }

  void callRest(telephon) async {
    await launch("tel://" + telephon);
  }

  void goToChat(user) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => PantallaChat(user: user)));
  }
}
