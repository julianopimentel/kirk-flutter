/*
import 'package:flutter/material.dart';

import '../../model/visitante.dart';

class VisitorDetailPage extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailPage({Key? key, required this.visitor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String genderText = '';
    if (visitor.sex == 'm') {
      genderText = 'Masculino';
    } else if (visitor.sex == 'f') {
      genderText = 'Feminino';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Visitante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${visitor.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('Telefone: ${visitor.phone}'),

            Text('Email: ${visitor.email == null ? 'Não Informado' : visitor.email}'),
            Text('Data de Nascimento: ${visitor.aniversario == null ? 'Não Informado' : visitor.aniversario}'),
            Text('Gênero: $genderText'), // Mostra o gênero do visitante
            // Você pode adicionar mais informações do visitante conforme necessário
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import '../../model/visitante.dart';

class VisitorDetailModal extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailModal({super.key, required this.visitor});

  // converter a data para o formato dd/mm/yyyy
  DateTime convertListToDate(List<int> dateList) {
    if (dateList.length == 3) {
      int year = dateList[0];
      int month = dateList[1];
      int day = dateList[2];
      return DateTime(year, month, day);
    }
    // Caso a lista não tenha os três valores necessários, retorne null ou uma data padrão, dependendo do seu caso.
    return DateTime(2000, 1, 1); // Data padrão, por exemplo.
  }

  String? formatDate(List<int>? dateList) {
    if (dateList == null || dateList.length != 3) {
      return 'Data de Nascimento Não Disponível'; // Ou qualquer mensagem padrão que você desejar
    }

    DateTime date = convertListToDate(dateList);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {

    String genderText = '';
    if (visitor.sex == 'm') {
      genderText = 'Masculino';
    } else if (visitor.sex == 'f') {
      genderText = 'Feminino';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nome: ${visitor.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Telefone: ${visitor.phone}'),
          Text('Email: ${visitor.email}'),
          Text(
            'Gênero: ${visitor.sex != null ? genderText : 'Não Informado'}',
          ),
          Text(
            'Data de Nascimento: ${visitor.birthAt != null ? formatDate(visitor.birthAt) : 'Não Informado'}',
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o modal
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
