import 'dart:typed_data';
import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/screens/pantalla_login.dart';
import 'package:bhungry/screens/pantalla_selectora.dart';
import 'package:bhungry/utilities/str_transformer.dart';
import 'package:bhungry/utilities/utils.dart';
import 'package:bhungry/widgets/custom_rounded_button.dart';
import 'package:bhungry/widgets/divider_gradient.dart';
import 'package:bhungry/widgets/mobile_screen_layout.dart';
import 'package:bhungry/widgets/register_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';
import '../resources/auth_methods.dart';

class PantallaConfRest extends StatefulWidget {
  const PantallaConfRest({Key? key}) : super(key: key);

  @override
  State<PantallaConfRest> createState() => _PantallaConfRestState();
}

class _PantallaConfRestState extends State<PantallaConfRest> {
  final TextEditingController _nomTextDitingController =
      TextEditingController();
  final TextEditingController _descripcionTextDitingController =
      TextEditingController();
  final TextEditingController _emailTextDitingController =
      TextEditingController();
  final TextEditingController _telefonosTextDitingController =
      TextEditingController();
  final TextEditingController _ubicacionTextDitingController =
      TextEditingController();
  final TextEditingController _webPageTextDitingController =
      TextEditingController();

  bool _isLoading = false;
  bool patchImgs = false;
  List<Uint8List> _images = [];
  String googleApikey = "AIzaSyDXZHR0-Zws0Q_hKSgoq2pYuYhZwir-S0M";
  String location = "Search Location";
  double? lat;
  double? long;
  bool isLoading = false;
  model.User? user;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      user = model.User.fromJson(userSnap.data()!);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && user!.imagenesRest != [] && !patchImgs) {
      tempFunc(user!);
      patchImgs = true;
    }

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 50),
                      child: Row(
                        children: [
                          Text(
                            "Perfil Empresa",
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 36,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        _images != [] && _images.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 20, top: 20),
                                height: 270,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _images.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 270,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        FittedBox(
                                            fit: BoxFit.fill,
                                            child:
                                                Image.memory(_images[index])),
                                        Container(
                                            color: const Color.fromRGBO(
                                                255, 255, 244, 0.5),
                                            child: IconButton(
                                                onPressed: () {
                                                  _images.removeAt(index);
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )))
                                      ],
                                    );
                                  },
                                ),
                              )
                            : user!.imagenesRest != [] &&
                                    user!.imagenesRest!.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                        bottom: 20,
                                        top: 20),
                                    height: 270,
                                    child: GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: user!.imagenesRest!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 270,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            FittedBox(
                                                fit: BoxFit.fill,
                                                child: Image.network(user!
                                                    .imagenesRest![index])),
                                            Container(
                                                color: const Color.fromRGBO(
                                                    255, 255, 244, 0.5),
                                                child: IconButton(
                                                    onPressed: () {
                                                      user!.imagenesRest!
                                                          .removeAt(index);
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    )))
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                  ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: ElevatedButton(
                            onPressed: selectImage,
                            child: const Icon(Icons.add_a_photo,
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              primary: const Color(0xffF3953D)
                                  .withOpacity(0.5), // <-- Button color
                              onPrimary:
                                  const Color(0xffF6DE04), // <-- Splash color
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user!.username,
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900)))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user!.email,
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff898989))),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const dividerGradient(),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Datos Empresa",
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            )),
                          ),
                        ],
                      ),
                    ),
                    registerInput(
                      placeholder: "Ex: Restaurante Can Roqueta",
                      title: "Nombre Restaurante",
                      textEditingController: _nomTextDitingController,
                      textInputType: TextInputType.text,
                      initValue: user!.username,
                    ),
                    registerInput(
                      placeholder:
                          "Ex: Restaurante con comida tipica catalana, ideal para eventos familiares o con amigos. ",
                      title: "Descripción",
                      textEditingController: _descripcionTextDitingController,
                      textInputType: TextInputType.multiline,
                      numLineas: null,
                      initValue: user!.descripcion ?? "",
                    ),
                    registerInput(
                        placeholder: "Ex: canRoqueta@gmail.com",
                        title: "Email",
                        textEditingController: _emailTextDitingController,
                        textInputType: TextInputType.emailAddress,
                        initValue: user!.email),
                    registerInput(
                        placeholder: "Ex: www.restaurante.com",
                        title: "Pagina Web",
                        textEditingController: _webPageTextDitingController,
                        textInputType: TextInputType.text,
                        initValue: user!.webPage ?? ""),
                    registerInput(
                      placeholder: "Ex: 903 65 78 77, 607 89 88 56",
                      title: "Telefono",
                      textEditingController: _telefonosTextDitingController,
                      textInputType: TextInputType.text,
                      initValue: user!.telefonos ?? "",
                    ),
                    // components: [Component(Component.country, 'es')],

                    InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApikey,
                            mode: Mode.overlay,
                            types: [],
                            strictbounds: false,
                            components: [],
                            onError: (err) {
                              print(err);
                            });

                        if (place != null) {
                          _ubicacionTextDitingController.text =
                              place.description.toString();

                          final plist = GoogleMapsPlaces(
                            apiKey: googleApikey,
                            apiHeaders:
                                await const GoogleApiHeaders().getHeaders(),
                          );
                          String placeid = place.placeId ?? "0";
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          lat = geometry.location.lat;
                          long = geometry.location.lng;
                        }
                      },
                      child: IgnorePointer(
                        child: registerInput(
                            placeholder: "Ex: Sant Jaume 20, Barcelona",
                            title: "Ubicacion",
                            textEditingController:
                                _ubicacionTextDitingController,
                            textInputType: TextInputType.text,
                            initValue: user!.ubicacion ?? ""),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: user!.firstLogin
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        iconTextButton(
                          icono: Icons.save,
                          text: "Guardar",
                          borderRadius: 30,
                          press: () => saveRestConf(user),
                        ),
                        user!.firstLogin
                            ? iconTextButton(
                                icono: Icons.logout,
                                text: "Logout",
                                borderRadius: 30,
                                gradientInverted: true,
                                press: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PantallaLoginIn()));
                                },
                              )
                            : Container(),
                      ],
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

  saveRestConf(user) async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().updateRest(
        userInfo: user,
        context: context,
        email: _emailTextDitingController.text,
        username: _nomTextDitingController.text,
        descripcion: _descripcionTextDitingController.text,
        telefono: _telefonosTextDitingController.text,
        ubicacion: _ubicacionTextDitingController.text,
        webPage: _webPageTextDitingController.text,
        imgs: _images,
        lat: lat,
        long: long);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context, Colors.red);
    } else {
      showSnackBar("Informacion guardada correctamente", context, Colors.green);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const PantallaSelectora(
                mobileScreenLayout: MobileScreenLayout(),
              )));
    }
  }

  void selectImage() async {
    List<Uint8List>? img = await pickImages();

    setState(() {
      if (img != null) {
        _images += img;
      }
    });
  }

  Future<List<Uint8List>> urlToBytes(List<String> urls) async {
    List<Uint8List> imgBytes = [];

    for (var url in urls) {
      Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      imgBytes.add(bytes);
    }

    return imgBytes;
  }

  void tempFunc(model.User user) async {
    if (mounted) {
      _images = await urlToBytes(user.imagenesRest!);
      setState(() {});
    }
  }
}
