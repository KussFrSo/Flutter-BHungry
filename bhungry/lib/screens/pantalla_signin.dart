import 'package:bhungry/components/signin_components.dart';
import 'package:bhungry/resources/auth_methods.dart';
import 'package:bhungry/screens/pantalla_conf_restaurant.dart';
import 'package:bhungry/screens/pantalla_conf_user.dart';
import 'package:bhungry/utilities/utils.dart';
import 'package:bhungry/widgets/tittle_with_underline.dart';
import 'package:bhungry/widgets/top_img_stack.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';
import '../widgets/dropdown.dart';

class Pantalla_Signin extends StatefulWidget {
  const Pantalla_Signin({Key? key}) : super(key: key);

  @override
  State<Pantalla_Signin> createState() => _Pantalla_SigninState();
}

class _Pantalla_SigninState extends State<Pantalla_Signin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String tipo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  topImgLogIn(
                    url: "assets/img/fondo_singin_top.png",
                    title: "Crear",
                    secondTitle: "Cuenta",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownInput(
                        callback: callback, placeholder: "Tipo de usuario"),
                  ),
                  SigInComponents(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    nameController: _nameController,
                  ),
                  Stack(alignment: Alignment.bottomRight, children: [
                    Image.asset("assets/img/fondo_signin_bot.png"),
                    Positioned(
                      top: 15,
                      left: 50,
                      child: Text("Regístrate",
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w900))),
                    ),
                    Positioned(
                      bottom: 130,
                      right: 50,
                      child: ElevatedButton(
                        child: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () => signUpUser(),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff4C525C),
                          fixedSize: const Size(64, 64),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 50,
                      child: tittleWithUnderline(
                        textHint: "Inicia Sesión",
                        press: () => moveToLogIn(context),
                        underlineColor: const Color(0xFFF6DE04),
                      ),
                    )
                  ]),
                ],
              ),
      ),
    );
  }

  callback(newValue) {
    setState(() {
      tipo = newValue;
    });
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
        tipoUser: tipo);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context, Colors.red);
    } else {
      addData();
      if (tipo == "Usuario") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PantallaConfUser()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PantallaConfRest()));
      }
    }
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  moveToLogIn(context) {
    Navigator.pop(context);
  }
}
