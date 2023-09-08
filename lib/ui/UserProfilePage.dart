import 'package:KirkDigital/ui/componentes/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/users_me.dart';
import '../provider/account_provider.dart';
import 'componentes/data_field.dart';
import 'componentes/email_field.dart';
import 'componentes/foto_field.dart';
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

  String? image;

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
    // Acesse o provider e chame o método para listar os grupos de permissão
    AccountProvider accountProvider = context.read<AccountProvider>();
    UsersMe me = accountProvider.getMe();
    _nameController.text = me.name ?? '';
    _phoneController.text = me.phone ?? '';
    _emailController.text = me.email ?? '';
    image = me.image;
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
            Center(
              child: FotoField(
                imageUrl: image,
                name: _nameController.text,
                imageSize: 150.0,
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 20),
            NomeField(
                controller: TextEditingController(text: _nameController.text),
            ),
            TelefoneField(
                controller: TextEditingController(text: _phoneController.text),
            ),
            EmailField(
                controller: TextEditingController(text: _emailController.text),
                enabled: true),

            CustomElevatedButton(
                onPressed:  () {}
                , label: 'Atualizar')
          ],
        ),
      ),
    );
  }
}
