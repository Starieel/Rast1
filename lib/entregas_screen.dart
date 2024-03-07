import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PedidoDetailsPage.dart';
import 'criarPedido.dart'; // Import the criarPedido.dart file

class EntregasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entregas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CriarPedido()), // Navigate to criarPedido.dart
              );
            },
          ),
        ],
      ),
      body: _buildPedidoList(context),
    );
  }

  Widget _buildPedidoList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Pedido').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No pedidos available'),
          );
        }

        return ListView(
          padding: EdgeInsets.all(8.0),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String nome = data['nome'] ?? '';
            String telefone = data['telefone'] ?? '';
            String endereco = data['endereco'] ?? '';
            String numero = data['número'] ?? '';
            String bairro = data['bairro'] ?? '';
            String cidade = data['cidade'] ?? '';
            String cep = data['cep'] ?? '';
            String pedido = data['pedido'] ?? '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PedidoDetailsPage(
                      nome: nome,
                      telefone: telefone,
                      endereco: endereco,
                      numero: numero,
                      bairro: bairro,
                      cidade: cidade,
                      cep: cep,
                      pedido: pedido,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: $nome', style: TextStyle(fontSize: 16.0)),
                    Text('Telefone: $telefone', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
