import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/person.dart';
import '../../provider/pessoa_provider.dart';
import '../componentes/custom_campo_field.dart';
import '../componentes/data_field.dart';
import '../componentes/email_field.dart';
import '../componentes/foto_field.dart';
import '../componentes/nome_field.dart';
import '../componentes/telefone_field.dart';

class PessoaDetailPage extends StatelessWidget {
  final int id;

  const PessoaDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Pessoa?>(
      future: context.read<PessoaProvider>().getById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se os dados ainda estão sendo carregados, você pode exibir um indicador de carregamento
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Pessoa'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          // Se ocorreu um erro ou a pessoa não foi encontrada
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Pessoa'),
            ),
            body: const Center(
              child: Text('Pessoa não encontrada.'),
            ),
          );
        } else {
          // Se a pessoa foi encontrada com sucesso
          final Pessoa pessoa = snapshot.data!;

          String genderText = '';
          if (pessoa.sex == 'm') {
            genderText = 'Masculino';
          } else if (pessoa.sex == 'f') {
            genderText = 'Feminino';
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Pessoa'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FotoField(
                      imageUrl: pessoa.image,
                      name: pessoa.name,
                      imageSize: 150.0,
                      fontSize: 50.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NomeField(
                      controller: TextEditingController(text: pessoa.name),
                      enabled: true),
                  TelefoneField(
                      controller: TextEditingController(text: pessoa.phone),
                      enabled: true),
                  EmailField(
                      controller: TextEditingController(text: pessoa.email),
                      enabled: true),
                  if (pessoa.birthAt != null)
                    DataField(
                        label: 'Data de nascimento',
                        onDataSelect: (data) {
                        },
                        selectedDate: pessoa.birthAt == null
                            ? null
                            : DateTime(pessoa.birthAt![0], pessoa.birthAt![1],
                                pessoa.birthAt![2]),
                        enabled: false),
                  CustomCampoField(
                      controller: TextEditingController(text: genderText),
                      label: 'Gênero',
                      enabled: true),
                  CustomCampoField(
                      controller: TextEditingController(text: pessoa.roles),
                      label: 'Grupo de Permissão',
                      enabled: true),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
