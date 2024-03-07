import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CriarPedido extends StatefulWidget {
  final Color backgroundColor;
  final double containerDistance;
  final double fontSize;
  final Color textColor;

  const CriarPedido({
    Key? key,
    this.backgroundColor = Colors.white,
    this.containerDistance = 10.0,
    this.fontSize = 16.0,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  _CriarPedidoState createState() => _CriarPedidoState();
}

class _CriarPedidoState extends State<CriarPedido> {
  String nome = '';
  String telefone = '';
  String endereco = '';
  String numero = '';
  String bairro = '';
  String cidade = '';
  String cep = '';
  String pedido = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Pedido'), // Title of the screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome', (value) => nome = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Telefone', (value) => telefone = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Endereço', (value) => endereco = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Número', (value) => numero = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Bairro', (value) => bairro = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Cidade', (value) => cidade = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('CEP', (value) => cep = value),
              SizedBox(height: widget.containerDistance),
              _buildTextField('Pedido', (value) => pedido = value),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _savePedidoToFirebase();
                  Navigator.pop(context); // Navigate back to the previous screen
                },
                child: Text(
                  'Salvar Pedido',
                  style: TextStyle(fontSize: widget.fontSize, color: widget.textColor),
                ),
                style: ElevatedButton.styleFrom(
                  primary: widget.backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: widget.textColor, fontSize: widget.fontSize),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: widget.textColor),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _savePedidoToFirebase() {
    FirebaseFirestore.instance.collection('Pedido').add({
      'nome': nome,
      'telefone': telefone,
      'endereco': endereco,
      'número': numero,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'pedido': pedido,
      'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for ordering
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido Salvo', style: TextStyle(color: widget.textColor))),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar pedido: $error', style: TextStyle(color: widget.textColor))),
      );
    });
  }
}