import 'package:KirkDigital/ui/componentes/custom_elevated_button.dart';
import 'package:KirkDigital/utils/toastr_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/person_me.dart';
import '../provider/account_provider.dart';
import 'componentes/email_field.dart';
import 'componentes/foto_nova_field.dart';
import 'componentes/nome_field.dart';
import 'componentes/telefone_field.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedImageFile;


  _phoneChanged(String value) {
    setState(() {
      _phoneController.text = value;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carregar os dados do usuário
  }

  Future<void> _loadUserData() async {
    try {
      // Obter os dados pessoais do usuário usando o método assíncrono
      PersonMe personMe = await context.read<AccountProvider>().getDadosPessoais(context);
      // Preencher os controladores de texto com os dados obtidos
      _nameController.text = personMe.name ?? '';
      _phoneController.text = personMe.phone ?? '';
      _emailController.text = personMe.email ?? '';
      _selectedImageFile = personMe.image;
      setState(() {
      }); // Atualizar o estado para exibir a imagem
    } catch (error) {
      // Lidar com erros, se necessário
      print("Erro no carregamento do usuário person: $error");
    }
  }

  _onImageSelected(String base64ImageData) {
    setState(() {
      _selectedImageFile = base64ImageData;
    });
  }



  Future<void> _updateUserData() async {

  // Obtenha os dados do usuário dos controladores de texto
  String name = _nameController.text;
  String phone = _phoneController.text;
  String image = _selectedImageFile ?? '';

  // Chame a função para atualizar os dados do usuário (substitua pelo seu código real)
  await context.read<AccountProvider>().putDadosPessoais(name: name, phone: phone, image: image);

  // Atualize os dados do usuário na tela
  await _loadUserData();

  // Exiba uma mensagem de sucesso
  NotificationUtils.showSuccess(context, 'Dados atualizados com sucesso');


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Pessoais'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FotoNovaField(
              name: _nameController.text,
              imageUrl: _selectedImageFile,
              imageSize: 100.0,
              fontSize: 40.0,
              isEditable: true,
              selectedImageFilePath: _selectedImageFile,
              onImageSelected: (String? imagePath) {
                if (imagePath != null) {
                  _onImageSelected(imagePath);
                }
              },
            ),
            const SizedBox(height: 20),
            NomeField(
                controller: TextEditingController(text: _nameController.text),
                onValueChanged: (value) {
                  _nameController.text = value;
                }
            ),
            TelefoneField(
                controller: TextEditingController(text: _phoneController.text),
                onValueChanged: (value) {
                  _phoneController.text = value;
                }
            ),
            EmailField(
                controller: TextEditingController(text: _emailController.text),
                enabled: true),

            CustomElevatedButton(
                onPressed: _updateUserData, // Chame o método _updateUserData
                label: 'Atualizar')
          ],
        ),
      ),
    );
  }
}