import 'package:flutter/material.dart';
import 'package:examen_final_sureda/models/models.dart';

Future<void> startUrl(BuildContext context, Plato plato) async {
  Navigator.pushNamed(context, 'mapa', arguments: plato);
}