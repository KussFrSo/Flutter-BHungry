//Pantalla que coge la info de FireBase y seleciona a que pantalla tiene que abrir
import 'package:bhungry/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_providers.dart';

class PantallaSelectora extends StatefulWidget {
  final Widget mobileScreenLayout;

  const PantallaSelectora({Key? key, required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<PantallaSelectora> createState() => _PantallaSelectoraState();
}

class _PantallaSelectoraState extends State<PantallaSelectora> {
  @override
  void initState() {
    super.initState();
    addData();
    getRestaurantes();
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void getRestaurantes() async {
    CardProvider _cardProvider = Provider.of(context, listen: false);
    await _cardProvider.getActualPosition();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return widget.mobileScreenLayout;
        }
        return Container(
          child: Text("Error"),
        );
      },
    );
  }
}
