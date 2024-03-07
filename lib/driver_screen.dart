import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'entregas_screen.dart';
import 'rota_screen.dart';
import 'package:geolocator/geolocator.dart';

class DriverScreen extends StatefulWidget {
  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  int _selectedIndex = 0;
  String _driverName = '';
  Position? _currentPosition;

  List<Widget> _widgetOptions = <Widget>[
    EntregasScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _recuperarLocalizacaoAtual();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNameInputDialog(context);
    });
  }

_recuperarLocalizacaoAtual() async {
  Geolocator.getPositionStream().listen((Position position) {
    setState(() {
      _currentPosition = position;
    });
    // Access latitude and longitude from the position object
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    
    // Update driver info in Firebase
    _saveDriverInfoToFirebase();
  });
}


  Future<void> _showNameInputDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (value) {
                    setState(() {
                      _driverName = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_driverName.isNotEmpty) {
                  _saveDriverInfoToFirebase();
                  Navigator.of(context).pop();
                } else {
                  // Handle empty name
                  // Show a message or perform an action
                }
              },
            ),
          ],
        );
      },
    );
  }

 void _saveDriverInfoToFirebase() {
  if (_currentPosition != null) {
    FirebaseFirestore.instance.collection('Motoristas').doc(_driverName).set({
      "Nome": _driverName,
      "Localizacao": {
        "latitude": _currentPosition!.latitude, // Using null check operator
        "longitude": _currentPosition!.longitude, // Using null check operator
      },
    });
  }
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 0, 150, 92),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Entregas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Rota',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 74, 255, 225),
        onTap: _onItemTapped,
      ),
    );
  }
}
