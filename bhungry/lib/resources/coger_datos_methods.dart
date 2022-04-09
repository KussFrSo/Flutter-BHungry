import 'package:bhungry/models/card.dart';
import 'package:bhungry/resources/distance_methods.dart';
import 'package:bhungry/utilities/str_transformer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bhungry/models/users.dart' as model;

class CogerDatosMethods {
  final _firestore = FirebaseFirestore.instance;
  double lat;
  double long;

  CogerDatosMethods({required this.lat, required this.long});

  Future<List<CardRest>> getRestaurantes() async {
    double distanciaABuscar;
    Map<String, CardRest> objCardRest = <String, CardRest>{};
    String distanceStr;

    CollectionReference usersRef = _firestore.collection("users");
    QuerySnapshot query =
        await usersRef.where("tipoUser", isEqualTo: "Restaurante").get();

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    model.User user = model.User.fromSnap(snap);

    for (var document in query.docs) {
      distanciaABuscar = user.distanciaBuscadora ?? 0.0;
      double latRest = document["lat"] ?? 0.0;
      double longRest = document["long"] ?? 0.0;
      double distance =
          DistanceMethods().getDistance(lat, long, latRest, longRest);
      distance = distance / 1000;
      distanceStr = distance.toStringAsFixed(0);
      if (int.parse(distanceStr) < 1) {
        distanceStr = "1";
      }
      if (int.parse(distanceStr) <= distanciaABuscar) {
        objCardRest.putIfAbsent(
            document.id,
            () => CardRest(
                  nombre: document['username'],
                  distancia: "$distanceStr Km",
                  id: document['uid'],
                  urlImage: document['imagenesRest'] != null &&
                          document['imagenesRest'] != ""
                      ? document['imagenesRest'].cast<String>()
                      : [
                          "https://intratex.com/public/images/NoImagePlaceholder.png"
                        ],
                ));
      }
    }
    return objCardRest.values.toList();
  }
}
