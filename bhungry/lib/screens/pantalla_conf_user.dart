import 'dart:typed_data';
import 'package:bhungry/providers/user_providers.dart';
import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/resources/auth_methods.dart';
import 'package:bhungry/screens/pantalla_login.dart';
import 'package:bhungry/screens/pantalla_selectora.dart';
import 'package:bhungry/utilities/constants.dart';
import 'package:bhungry/utilities/slider_gradient.dart';
import 'package:bhungry/utilities/utils.dart';
import 'package:bhungry/widgets/custom_rounded_button.dart';
import 'package:bhungry/widgets/divider_gradient.dart';
import 'package:bhungry/widgets/mobile_screen_layout.dart';
import 'package:bhungry/widgets/register_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PantallaConfUser extends StatefulWidget {
  const PantallaConfUser({Key? key}) : super(key: key);

  @override
  State<PantallaConfUser> createState() => _PantallaConfUserState();
}

class _PantallaConfUserState extends State<PantallaConfUser> {
  final TextEditingController _nomTextDitingController =
      TextEditingController();
  final TextEditingController _emailTextDitingController =
      TextEditingController();
  final TextEditingController _telefonoTextDitingController =
      TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  double rangoDistancia = 150.0;
  bool distanceGetIt = false;
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
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (!distanceGetIt && !_isLoading) {
        rangoDistancia = user!.distanciaBuscadora ?? 5.0;
        distanceGetIt = true;
      }
    });

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
                            "Perfil",
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
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          alignment: Alignment.center,
                          child: _image != null
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(_image!),
                                  backgroundColor: Colors.transparent,
                                  radius: 64,
                                )
                              : user!.imagenes == null || user!.imagenes == ""
                                  ? const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 64,
                                      backgroundImage: AssetImage(
                                          "assets/img/no_img_perfil.png"),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 64,
                                      backgroundImage: NetworkImage(
                                          user!.imagenes.toString()),
                                    ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 220,
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
                            ))
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
                            "Datos Personales",
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
                        placeholder: "Ex: Pepe Jose",
                        title: "Nombre",
                        textEditingController: _nomTextDitingController,
                        textInputType: TextInputType.text,
                        initValue: user!.username),
                    registerInput(
                      placeholder: "Ex: pepitoJose@gmail.com",
                      title: "Email",
                      textEditingController: _emailTextDitingController,
                      textInputType: TextInputType.text,
                      initValue: user!.email,
                    ),
                    registerInput(
                      placeholder: "Ex: 607 89 88 56",
                      title: "Telefono",
                      textEditingController: _telefonoTextDitingController,
                      textInputType: TextInputType.text,
                      initValue: user!.telefonos ?? "",
                    ),
                    //Barra para selecionar el rango
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        const Text(
                          "Rango de distancia",
                          style: TextStyle(color: Colors.black45),
                        ),
                        IconButton(
                            onPressed: () => showAlert(
                                context,
                                "Distancia maxima a la que quieres que se busquen los restaurantes",
                                "Información"),
                            icon: const Icon(
                              Icons.info,
                              color: Colors.amber,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                                thumbColor: Colors.amber,
                                overlayColor: Colors.amber.shade300,
                                valueIndicatorColor: Colors.orange.shade300,
                                trackShape: const GradientRectSliderTrackShape(
                                    gradient: gradient),
                                inactiveTrackColor: Colors.amber.shade100),
                            child: Slider(
                                value: rangoDistancia,
                                min: 5,
                                max: 300,
                                divisions: 300,
                                label: rangoDistancia.round().toString() + "Km",
                                onChanged: (value) => setState(() {
                                      rangoDistancia = value;
                                    })),
                          ),
                        ),
                        Text(
                          rangoDistancia.toStringAsFixed(0) + "Km",
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
                          press: () => saveUserConf(user),
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

  saveUserConf(user) async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().updateUser(
      userInfo: user,
      context: context,
      email: _emailTextDitingController.text,
      username: _nomTextDitingController.text,
      telefono: _telefonoTextDitingController.text,
      distanciaBuscadora: rangoDistancia,
      img: _image,
    );

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
    Uint8List? img = await pickImage(ImageSource.gallery);

    setState(() {
      if (img != null) {
        _image = img;
      }
    });
  }

  Future<List<Uint8List>> urlToBytes(List<String> urls) async {
    List<Uint8List> imgBytes = [];

    urls.forEach((url) async {
      http.Response response = await http.get(
        Uri.parse(url),
      );
      imgBytes.add(response.bodyBytes);
    });

    return imgBytes;
  }
}
