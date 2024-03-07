import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RotaScreen extends StatefulWidget {
  final String endereco;
  final String numero;
  final String bairro;
  final String cidade;
  final String cep;

  const RotaScreen({
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cep,
  });

  @override
  _RotaScreenState createState() => _RotaScreenState();
}

class _RotaScreenState extends State<RotaScreen> {
  late GoogleMapController _controller;
  LatLng? _origin; // Nullable type
  late LatLng _destination;
  late Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCoordinates();
  }

  Future<void> _getCoordinates() async {
    // Geocode the address to get coordinates
    final address = '${widget.endereco}, ${widget.numero}, ${widget.bairro}, ${widget.cidade}, ${widget.cep}';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyAogwVPfuiA37d_SVxrwhfXiVFk1dFuwZk'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results != null && results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        setState(() {
          _origin = LatLng(lat, lng);
        });
        _calculateRoute(_origin!);
      }
    } else {
      throw Exception('Failed to geocode address');
    }
  }
Future<void> _calculateRoute(LatLng origin) async {
  // Calculate route using Directions API
  final directions = await _getDirections(origin, _destination);

  // Draw polyline between origin and destination
  _addPolyline(directions);
}

Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
  final response = await http.get(Uri.parse(
    'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyAogwVPfuiA37d_SVxrwhfXiVFk1dFuwZk',
  ));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final routes = data['routes'];

    if (routes != null && routes.isNotEmpty) {
      final points = routes[0]['overview_polyline']['points'];
      return _convertToLatLng(_decodePolyline(points));
    }
  }

  throw Exception('Failed to get directions');
}

List<LatLng> _convertToLatLng(List points) {
  List<LatLng> result = <LatLng>[];
  for (int i = 0; i < points.length; i++) {
    if (i % 2 != 0) {
      result.add(LatLng(points[i - 1], points[i]));
    }
  }
  return result;
}

List _decodePolyline(String encoded) {
  List<int> polyline = [];
  int index = 0;
  int len = encoded.length;
  int currentLat = 0;
  int currentLng = 0;

  while (index < len) {
    int b;
    int shift = 0;
    int result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    currentLat += dlat;

    shift = 0;
    result = 0;

    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    currentLng += dlng;

    double lat = currentLat / 1e5;
    double lng = currentLng / 1e5;

    polyline.add((lat * 1e6).round());
    polyline.add((lng * 1e6).round());
  }

  return polyline;
}

void _addPolyline(List<LatLng> points) {
  setState(() {
    _polylines.clear();
    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: Colors.blue,
      width: 5,
    ));
  });
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Rota para ${widget.endereco}'),
    ),
    body: _origin == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _origin!,
              zoom: 14,
            ),
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });
            },
          ),
  );
}
}