import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/models.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng _originalLocation;
  MapType _currentMapType = MapType.normal;
  List<Marker> _markers = [];

  Future<void> _goToOriginalLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _originalLocation,
      zoom: 19.0,
    )));
  }

  // Método para cambiar el tipo de mapa
  void _onMapTypeButtonPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Normal'),
                  onTap: () {
                    _changeMapType(MapType.normal);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Satellite'),
                  onTap: () {
                    _changeMapType(MapType.satellite);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Terrain'),
                  onTap: () {
                    _changeMapType(MapType.terrain);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Hybrid'),
                  onTap: () {
                    _changeMapType(MapType.hybrid);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changeMapType(MapType type) async {
    setState(() {
      _currentMapType = type;
    });
  }

  //Botón para añadir un marcador
  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {},
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Plato plato =
        ModalRoute.of(context)!.settings.arguments as Plato;

    final CameraPosition camPos = CameraPosition(
      target: plato.getLatLng(),
      zoom: 19.151926040649414,
    );

    _originalLocation = plato.getLatLng();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () {
              _goToOriginalLocation();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: camPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              Marker(
                markerId: MarkerId('original_location'),
                position: _originalLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
              ..._markers,
            },
            onTap: (position) => _addMarker(position),
          ),
          Positioned(
            left: 12.0,
            bottom: 12.0,
            child: FloatingActionButton(
              onPressed: () {
                // Cambiar el tipo de mapa
                _onMapTypeButtonPressed();
              },
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.purple,
              child: const Icon(Icons.layers_outlined, size: 36.0),
            ),
          ),
        ],
      ),
    );
  }
}