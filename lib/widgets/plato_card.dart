import '../models/models.dart';
import 'package:flutter/material.dart';

class PlatoCard extends StatelessWidget {
  final Plato plato;
  const PlatoCard({super.key, required this.plato});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: plato.foto == null || plato.foto!.isEmpty
            ? AssetImage('assets/no-image.png')
            : NetworkImage(plato.foto!) as ImageProvider,
        child: plato.foto == null || plato.foto!.isEmpty
            ? Text(plato.nom[0])
            : null,
      ),
      title: Text(plato.nom),
    );
  }
}
