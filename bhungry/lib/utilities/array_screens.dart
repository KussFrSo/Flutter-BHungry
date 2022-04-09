import 'package:bhungry/screens/pantalla_calendari.dart';
import 'package:bhungry/screens/pantalla_chat.dart';
import 'package:bhungry/screens/pantalla_chats.dart';
import 'package:bhungry/screens/pantalla_conf_restaurant.dart';
import 'package:bhungry/screens/pantalla_conf_user.dart';
import 'package:bhungry/screens/pantalla_liked_rest.dart';
import 'package:bhungry/screens/pantalla_principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ScreensItemsUser = [
  PantallaLikedRest(),
  PantallaCalendar(),
  //Text("BHUNGRY LOGO"),
  PricipalHome(),
  PantallaChats(),
  PantallaConfUser(),
];

final ScreensItemRest = [
  PantallaChats(),
  PricipalHome(),
  PantallaConfRest(),
];
