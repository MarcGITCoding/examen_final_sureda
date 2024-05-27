import 'package:examen_final_sureda/models/models.dart';
import 'package:examen_final_sureda/services/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../preferences/preferences.dart';
import '../widgets/widgets.dart';
import '../ui/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platoService = Provider.of<PlatoService>(context);
    List<Plato> platos = platoService.platos;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              Preferences.user = '';
              Preferences.pass = '';
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: platos.isEmpty
          ? Loading()
          : ListView.builder(
              itemCount: platos.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: PlatoCard(plato: platos[index]),
                    onTap: () {
                      platoService.tempPlato = platos[index].copy();
                      Navigator.of(context).pushNamed('detail');
                    },
                  ),
                  onDismissed: (direction) {
                    if (platos.length < 2) {
                      platoService.loadPlatos();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('No es pot esborrar tots els elements!')));
                    } else {
                      platoService.deletePlato(platos[index]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${platoService.platos[index].nom} esborrat')));
                    }
                  },
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Cream un plat temporal nou, per diferenciar-lo d'un ja creat,
          // per que aquest no tindrà id encara, i d'aquesta forma sabrem
          // discernir al detailscreen que estam creant un plat nou i no
          // modificant un existent
          platoService.tempPlato = Plato(descripcio: '', geo: '', nom: '', restaurant: '', tipus: '', disponible: false);
          Navigator.of(context).pushNamed('detail');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
