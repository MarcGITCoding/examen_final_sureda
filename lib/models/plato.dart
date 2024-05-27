import 'dart:convert';

class Plato {
    String descripcio;
    bool disponible;
    String foto;
    String geo;
    String nom;
    String restaurant;
    String tipus;

    Plato({
        required this.descripcio,
        required this.disponible,
        required this.foto,
        required this.geo,
        required this.nom,
        required this.restaurant,
        required this.tipus,
    });

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
}
