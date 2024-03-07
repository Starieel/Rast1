// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'rota_screen.dart'; // Import the RotaScreen.dart file

class PedidoDetailsPage extends StatelessWidget {
  final String nome;
  final String telefone;
  final String endereco;
  final String numero;
  final String bairro;
  final String cidade;
  final String cep;
  final String pedido;

  PedidoDetailsPage({
    required this.nome,
    required this.telefone,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cep,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoContainer('Nome', nome),
              _buildInfoContainer('Telefone', telefone),
              _buildInfoContainer('Endereço', endereco),
              _buildInfoContainer('Número', numero),
              _buildInfoContainer('Bairro', bairro),
              _buildInfoContainer('Cidade', cidade),
              _buildInfoContainer('CEP', cep),
              _buildInfoContainer('Pedido', pedido),
              SizedBox(height: 20), // Add some space before the button
              ElevatedButton(
                onPressed: () {
                  _startRota(
                    context,
                    endereco,
                    numero,
                    bairro,
                    cidade,
                    cep,
                  );
                },
                child: Text('Iniciar Rota'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRota(
    BuildContext context,
    String endereco,
    String numero,
    String bairro,
    String cidade,
    String cep,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RotaScreen(
          endereco: endereco,
          numero: numero,
          bairro: bairro,
          cidade: cidade,
          cep: cep,
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8), // Add some space between title and value
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 30), // Add some space between containers
      ],
    );
  }
}
