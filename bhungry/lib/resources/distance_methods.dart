import 'package:geolocator/geolocator.dart';

class DistanceMethods {
  Future<bool> checkPermissions() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
    });

    return isEnabled;
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<String> askForPermision() async {
    String hasPermision = "success";
    LocationPermission permission = await Geolocator.checkPermission();

    while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      hasPermision = "Los permisos de localizacion estan denegados";
    }

    return hasPermision;
  }

  double getDistance(sLat, sLong, eLat, eLong) {
    double distance = Geolocator.distanceBetween(sLat, sLong, eLat, eLong);

    return distance;
  }
}
