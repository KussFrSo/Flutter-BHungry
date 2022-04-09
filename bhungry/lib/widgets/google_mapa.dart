import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UbiRest extends StatefulWidget {
  const UbiRest(
      {Key? key, required this.lat, required this.lng, required this.username})
      : super(key: key);
  final lat;
  final lng;
  final username;

  @override
  State<UbiRest> createState() => _UbiRestState();
}

class _UbiRestState extends State<UbiRest> {
  bool _mapCreated = false;
  final Set<Marker> _markers = Set();
  late LatLng _center;

  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.lat, widget.lng);
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _goToRestaurant();
    setState(() {
      _mapCreated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () => print("HELOO"),
        child: Stack(
          children: [
            GoogleMap(
              tiltGesturesEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(15, 25),
              padding: const EdgeInsets.only(bottom: 100),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            if (!_mapCreated) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    ]);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> _goToRestaurant() async {
    // mapController!.animateCamera(
    //     CameraUpdate.newLatLngZoom(LatLng(widget.lat, widget.lng), 11));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
            markerId: MarkerId('Restaurante'),
            position: LatLng(widget.lat, widget.lng),
            infoWindow: InfoWindow(
                title: widget.username,
                snippet: 'Bienvenido a ' + widget.username)),
      );
    });
  }
}
