import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String driverName;
  final double initialLatitude;
  final double initialLongitude;

  const MapScreen({
    required this.driverName,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map for ${widget.driverName}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLatitude, widget.initialLongitude),
          zoom: 15,
        ),
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('driverLocation'),
            position: LatLng(widget.initialLatitude, widget.initialLongitude),
            infoWindow: InfoWindow(
              title: widget.driverName,
              snippet: 'Localização do Motorista',
            ),
          ),
        },
      ),
    );
  }
}
