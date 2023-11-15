import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/visitante.dart'; // Importe a classe Visitor
import '../../provider/visitante_provider.dart';
import '../../utils/toastr_utils.dart';
import '../componentes/custom_elevated_button.dart';
import '../componentes/data_field.dart';
import '../componentes/dropdown_field.dart';
import '../componentes/email_field.dart';
import '../componentes/nome_field.dart';
import '../componentes/telefone_field.dart'; // Importe o provider de visitante

class CreateVisitPage extends StatefulWidget {
  const CreateVisitPage({super.key});

  @override
  createState() => _CreateVisitPageState();
}

class _CreateVisitPageState extends State<CreateVisitPage> {
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

  Future<void> _criarVisitante() async {
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
            title: const Text('Erro de validação'),
            content: const Text('Por favor, preencha todos os campos obrigatórios.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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
      await provider.createVisitor(newVisitor);

      NotificationUtils.showSuccess(context,
          'O visitante ${newVisitor.name} foi criado com sucesso.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Visitante'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // Ajuste o espaçamento lateral e vertical conforme necessário
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
            const SizedBox(height: 20), // Espaçamento entre a frase e o campo de nome
            NomeField(controller: _nameController, required: true),
            TelefoneField(controller: _phoneController),
            EmailField(controller: _emailController),
            DataField(
                label: 'Data de nascimento',
                selectedDate: _selectedDate,
                onDataSelect: _atualizarDataSelecionada),
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
