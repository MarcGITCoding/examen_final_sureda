import 'package:examen_final_sureda/services/plato_service.dart';
import 'package:examen_final_sureda/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platoForm = Provider.of<PlatoService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
        actions: [
          // Botón para guardar
          IconButton(
            onPressed: () {
              if (platoForm.isValidForm()) {
                platoForm.saveOrCreatePlato();
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.save),
          ),
          // Botón para el mapa si tempPlato.id no es null
          if (platoForm.tempPlato.id != null)
            IconButton(
              onPressed: () {
                startUrl(context, platoForm.tempPlato);
              },
              icon: Icon(Icons.map),
            ),
        ],
      ),
      body: _PlatoForm(),
    );
  }
}


class _PlatoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final platoForm = Provider.of<PlatoService>(context);
    final tempPlato = platoForm.tempPlato;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: _buildBoxDecoration(),
          child: Form(
            key: platoForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Stack(
                  children: [
                    PlatoImage(url: platoForm.tempPlato.foto),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();

                          //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                          final XFile? photo =
                              await _picker.pickImage(source: ImageSource.camera);

                          if (photo != null) platoForm.updateSelectedImage(photo.path);
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 10),
                TextFormField(
                  initialValue: tempPlato.nom,
                  onChanged: (value) => tempPlato.nom = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'El nom és obligatori';
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nom', labelText: 'Nom:'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: tempPlato.descripcio,
                  onChanged: (value) => tempPlato.descripcio = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'La descripcio és obligatori';
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Descripció', labelText: 'Descripció:'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: tempPlato.tipus,
                  onChanged: (value) => tempPlato.tipus = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'El tipus és obligatori';
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Tipus', labelText: 'Tipus:'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: tempPlato.restaurant,
                  onChanged: (value) => tempPlato.restaurant = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'El restaurant és obligatori';
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Restaurant', labelText: 'Restaurant:'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: tempPlato.geo,
                  onChanged: (value) => tempPlato.geo = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La geocalització és obligatori';
                    }

                    // Expresión regular para verificar el formato de las coordenadas
                    RegExp regex = RegExp(r'^-?\d{1,3}\.\d+,-?\d{1,3}\.\d+$');

                    if (!regex.hasMatch(value)) {
                      return 'Format de coordenades invàlid';
                    }

                    // Separar las coordenadas
                    List<String> parts = value.split(',');

                    // Convertir las partes a números
                    double? lat = double.tryParse(parts[0]);
                    double? lon = double.tryParse(parts[1]);

                    // Verificar si las coordenadas están dentro de los límites válidos
                    if (lat == null || lon == null ||
                        lat < -90 || lat > 90 ||
                        lon < -180 || lon > 180) {
                      return 'Coordenades no vàlides';
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Geo', labelText: 'Geo:'),
                ),
                SizedBox(height: 10),
                SwitchListTile.adaptive(
                  value: tempPlato.disponible,
                  title: Text('Disponible'),
                  activeColor: Colors.indigo,
                  // Funció resumida
                  onChanged: (value) {
                    platoForm.updateAvailability(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5),
        ],
      );
}
