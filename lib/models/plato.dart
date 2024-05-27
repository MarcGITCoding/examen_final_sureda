import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Plato {
    String descripcio;
    bool disponible;
    String? foto;
    String geo;
    String nom;
    String restaurant;
    String tipus;
    String? id;

    Plato({
        required this.descripcio,
        required this.disponible,
        this.foto,
        required this.geo,
        required this.nom,
        required this.restaurant,
        required this.tipus,
        this.id,
    });

    LatLng getLatLng() {
      final latLng = geo.substring(4).split(',');

      final latitude = double.parse(latLng[0]);
      final longitude = double.parse(latLng[1]);

      return LatLng(latitude, longitude);
    }

    factory Plato.fromJson(String str) => Plato.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Plato.fromMap(Map<String, dynamic> json) => Plato(
        descripcio: json["descripcio"],
        disponible: json["disponible"],
        foto: json["foto"],
        geo: json["geo"],
        nom: json["nom"],
        restaurant: json["restaurant"],
        tipus: json["tipus"],
    );

    Map<String, dynamic> toMap() => {
        "descripcio": descripcio,
        "disponible": disponible,
        "foto": foto,
        "geo": geo,
        "nom": nom,
        "restaurant": restaurant,
        "tipus": tipus,
    };

    Plato copy() => Plato(descripcio: descripcio, disponible: disponible, foto: foto, geo: geo, nom: nom, restaurant: restaurant, tipus: tipus, id: id);
}
