import 'dart:convert';
import 'dart:io';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlatoService extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String _baseUrl =
      "examen-practic-sim-default-rtdb.europe-west1.firebasedatabase.app";
  List<Plato> platos = [];
  late Plato tempPlato;
  Plato? newPlato;
  File? newPicture;

  PlatoService() {
    this.loadPlatos();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  updateAvailability(bool value) {
    this.tempPlato.disponible = value;
    notifyListeners();
  }

  updateSelectedImage(String path) {
    this.newPicture = File.fromUri(Uri(path: path));
    this.tempPlato.foto = path;
    notifyListeners();
  }

  loadPlatos() async {
    platos.clear();
    final url = Uri.https(_baseUrl, 'plats.json');
    final response = await http.get(url);
    final Map<String, dynamic> platosMap = json.decode(response.body);

    // Mapejam la resposta del servidor, per cada plat, el convertim a la classe i l'afegim a la llista
    platosMap.forEach((key, value) {
      final auxPlato = Plato.fromMap(value);
      auxPlato.id = key;
      platos.add(auxPlato);
    });

    notifyListeners();
  }

  Future saveOrCreatePlato() async {
    if (tempPlato.id == null) {
      //Cream el plat
      await this.createPlato();
    } else {
      //Actualitzam el plat
      await this.updatePlato();
    }
    loadPlatos();
  }

  updatePlato() async {
    final url = Uri.https(_baseUrl, 'plats/${tempPlato.id}.json');
    final response = await http.put(url, body: tempPlato.toJson());
    //final decodedData = response.body;
  }

  createPlato() async {
    final url = Uri.https(_baseUrl, 'plats.json');
    final response = await http.post(url, body: tempPlato.toJson());
    //final decodedData = json.decode(response.body);
  }

  deletePlato(Plato plato) async {
    final url = Uri.https(_baseUrl, 'plats/${plato.id}.json');
    final response = await http.delete(url);
    //final decodedData = json.decode(response.body);
    loadPlatos();
  }
}
