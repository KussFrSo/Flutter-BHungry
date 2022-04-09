import 'dart:math';
import 'package:bhungry/models/card.dart';
import 'package:bhungry/resources/coger_datos_methods.dart';
import 'package:bhungry/resources/distance_methods.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<CardRest> _urlImages = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  bool _next = false;

  List<CardRest> get getObjCards => _urlImages;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  bool get next => _next;
  double get angle => _angle;
  Position? actualPosition;

  CardProvider() {
    getActualPosition();
  }

  Future<void> getActualPosition() async {
    bool gpsEnabled = await DistanceMethods().checkPermissions();
    String mobilePermission = await DistanceMethods().askForPermision();

    if (gpsEnabled && mobilePermission == "success") {
      actualPosition = await DistanceMethods().getLocation();
      List<CardRest> urlImages = await CogerDatosMethods(
              lat: actualPosition!.latitude, long: actualPosition!.longitude)
          .getRestaurantes();
      _urlImages = urlImages;
      notifyListeners();
    }
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        like();
        _next = true;
        break;
      case CardStatus.dislike:
        dislike();
        _next = false;
        break;
      default:
    }
    resetposition();
  }

  void resetposition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;

    if (force) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      const delta = 20;
      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  Offset getPosition() {
    return _position;
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width / 2, 0);
    _nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));
    _urlImages.removeLast();
    resetposition();
  }
}
