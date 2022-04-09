import 'package:bhungry/components/login_components.dart';
import 'package:bhungry/models/users.dart' as model;
import 'package:bhungry/screens/pantalla_conf_restaurant.dart';
import 'package:bhungry/screens/pantalla_conf_user.dart';
import 'package:bhungry/screens/pantalla_selectora.dart';
import 'package:bhungry/screens/pantalla_signin.dart';
import 'package:bhungry/widgets/mobile_screen_layout.dart';
import 'package:bhungry/widgets/tittle_with_underline.dart';
import 'package:bhungry/widgets/top_img_stack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';
import '../resources/auth_methods.dart';
import '../utilities/utils.dart';

class PantallaLoginIn extends StatefulWidget {
  const PantallaLoginIn({Key? key}) : super(key: key);

  @override
  State<PantallaLoginIn> createState() => _PantallaLoginInState();
}

class _PantallaLoginInState extends State<PantallaLoginIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            topImgLogIn(
              url: "assets/img/fondo_login.png",
              title: "Bienvenido",
              secondTitle: "de nuevo",
            ),
            LogInComponents(
                emailController: _emailController,
                passwordController: _passwordController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Inicia Sesión",
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w900))),
                  ElevatedButton(
                    child: const Icon(Icons.arrow_forward_rounded),
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff4C525C),
                      fixedSize: const Size(64, 64),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tittleWithUnderline(
                    textHint: "Registrarse",
                    press: () => moveToRegister(context),
                    underlineColor: const Color(0xFFF6DE04),
                  ),
                  tittleWithUnderline(
                    textHint: "Olvidé la Contraseña",
                    press: () => moveToChangePass(context),
                    underlineColor: const Color(0xFFFFAE48),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context, Colors.red);
    } else {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      model.User user = model.User.fromSnap(snap);
      if (mounted) {
        addData();
        if (user.firstLogin == true) {
          Navigator.of(context, rootNavigator: true)
              .pushReplacement(MaterialPageRoute(
                  builder: (context) => const PantallaSelectora(
                        mobileScreenLayout: MobileScreenLayout(),
                      )));
        } else {
          if (user.tipoUser == "Restaurante") {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const PantallaConfRest()));
          } else {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const PantallaConfUser()));
          }
        }
      }
    }
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  moveToRegister(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (const Pantalla_Signin())),
    );
  }

  moveToChangePass(context) {}
}
