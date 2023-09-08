import 'package:KirkDigital/service/notification_service.dart';
import 'package:KirkDigital/ui/componentes/custom_elevated_button.dart';
import 'package:KirkDigital/ui/componentes/data_field.dart';
import 'package:KirkDigital/ui/componentes/email_field.dart';
import 'package:KirkDigital/ui/componentes/telefone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/visitante.dart'; // Importe a classe Visitor
import '../../provider/visitante_provider.dart';
import '../componentes/dropdown_field.dart';
import '../componentes/nome_field.dart'; // Importe o provider de visitante

class CriarVisitantePage extends StatefulWidget {
  @override
  _CriarVisitantePageState createState() => _CriarVisitantePageState();
}

class _CriarVisitantePageState extends State<CriarVisitantePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _selectedDate;

  // Lista de opções de gênero
  final List<DropdownItem> _genderItems = [
    DropdownItem(value: 'm', title: 'Masculino'),
    DropdownItem(value: 'f', title: 'Feminino'),
  ];
  DropdownItem? _selectedGenderItem;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _atualizarDataSelecionada(DateTime novaData) {
    setState(() {
      _selectedDate = novaData;
    });
  }

  void _criarVisitante() {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;

    //convertendo a data para o formato yyyy-01-01

    if (name.isEmpty) {
      // Validação simples para garantir que ambos os campos sejam preenchidos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro de validação'),
            content: Text('Por favor, preencha todos os campos obrigatórios.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Crie o objeto de visitante
      Visitor newVisitor = Visitor(
          name: name,
          phone: phone,
          email: email,
          birthAt: _selectedDate != null
              ? [_selectedDate!.year, _selectedDate!.month, _selectedDate!.day]
              : null,
          sex: _selectedGenderItem?.value,
          aniversario: '');

      // Acesse o provider e chame o método para criar um visitante
      final VisitorProvider provider = context.read<VisitorProvider>();
      provider.createVisitor(newVisitor);

      NotificationService.showNotification(
          'O visitante ${newVisitor.name} foi criado com sucesso.',
          NotificationType.success,
          context);

      // Navegue de volta para a lista de visitantes após a criação bem-sucedida
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Visitante'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // Ajuste o espaçamento lateral e vertical conforme necessário
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Preencha os campos abaixo para criar um visitante:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Tamanho da fonte da frase introdutória
              ),
            ),
            SizedBox(height: 20), // Espaçamento entre a frase e o campo de nome
            NomeField(controller: _nameController, obrigatorio: true),
            TelefoneField(controller: _phoneController),
            EmailField(controller: _emailController),
            DataField(
                label: 'Data de nascimento',
                selectedDate: _selectedDate,
                onDataSelecionada: _atualizarDataSelecionada),
            DropdownField(
              label: 'Gênero',
              selectedValue: _selectedGenderItem,
              items: _genderItems,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  _selectedGenderItem = newValue;
                });
              },
            ),
            CustomElevatedButton(onPressed: _criarVisitante, label: 'Salvar')
          ],
        ),
      ),
    );
  }
}
