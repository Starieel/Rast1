import 'package:flutter/material.dart';
import 'admin_screen.dart';
import 'driver_screen.dart';
import 'client_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Container Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContainerScreen(),
    );
  }
}

class ContainerScreen extends StatefulWidget {
  @override
  _ContainerScreenState createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  int _selectedIndex = -1; // Initially no container is selected

  void _onContainerTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 122, 255, 211),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomContainer(
              text: 'Administração',
              onTap: () {
                _onContainerTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminScreen()),
                );
              },
              isSelected: _selectedIndex == 0,
            ),
            CustomContainer(
              text: 'Motorista',
              onTap: () {
                _onContainerTapped(1);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverScreen()),
                );
              },
              isSelected: _selectedIndex == 1,
            ),
            CustomContainer(
              text: 'Cliente',
              onTap: () {
                _onContainerTapped(2);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientScreen()),
                );
              },
              isSelected: _selectedIndex == 2,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  CustomContainer({
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 62, 252, 141) : Color.fromARGB(255, 0, 73, 61),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black),
        ),
        child: Center( // Center the text horizontally and vertically
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Color.fromARGB(255, 0, 92, 3) : Color.fromARGB(255, 0, 255, 21),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}