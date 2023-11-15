import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/simples_pessoa_dto.dart';
import '../../provider/pessoa_provider.dart';
import '../componentes/foto_field.dart';
import '../../ui/pessoa/pessoa_create_page.dart';
import '../../ui/pessoa/pessoa_detail_page.dart';


class PessoaListPage extends StatefulWidget {
  const PessoaListPage({super.key});

  @override
  createState() => _PessoaListPageState();
}

class _PessoaListPageState extends State<PessoaListPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    PessoaProvider provider = context.read<PessoaProvider>();
    await provider.getList();
  }

  // Função para exibir um diálogo de confirmação
  Future<void> _showDeleteConfirmationDialog(SimplesPessoaDto pessoa, PessoaProvider provider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // O diálogo não pode ser fechado tocando fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Pessoa'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza de que deseja excluir esta pessoa?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                // Atualize a lista e notifique os ouvintes
                Navigator.of(context).pop(); // Feche o diálogo
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                _onDeleteConfirmed(pessoa, provider);
                Navigator.of(context).pop(); // Feche o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void _onDeleteConfirmed(SimplesPessoaDto pessoa, PessoaProvider provider) async {
    await provider.delete(pessoa.id!, context);
    await provider.getList();
    setState(() {}); // Atualize a interface do usuário após a exclusão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pessoa'),
      ),
      body: Consumer<PessoaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            // Se os dados ainda estão sendo carregados, exiba um indicador de carregamento
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.pessoas.isEmpty) {
            // Se não há visitantes, você pode exibir uma mensagem de "nenhum visitante encontrado"
            return const Center(
              child: Text('Nenhum registro encontrado.'),
            );
          } else {
            // Caso contrário, exiba a lista de visitantes com opção de exclusão
            return ListView.builder(
              itemCount: provider.pessoas.length,
              itemBuilder: (BuildContext context, int index) {
                SimplesPessoaDto pessoa = provider.pessoas[index];
                return Card(
                  elevation: 4, // Define a elevação do card
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16), // Define as margens do card
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: FotoField(
                      imageUrl: pessoa.image,
                      name: pessoa.name,
                      identifier: ValueKey<int>(pessoa.id!),
                    ),
                    title: Text(
                      pessoa.name ?? '',
                      style: const TextStyle(
                        fontSize:
                            16, // Ajuste o tamanho da fonte conforme necessário
                      ),
                    ),
                    onTap: () {
                      // Exiba o diálogo de detalhes do visitante
                      _mostrarMenuOpcoes(context, pessoa, provider);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const PessoaCreatePage(), // Substitua com o nome da sua tela de criação
            ),
          );
        },
        child: const Icon(Icons.add), // Ícone de adição
      ),
    );
  }

  void _mostrarMenuOpcoes(
      BuildContext context, SimplesPessoaDto pessoa, PessoaProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('Visualizar'),
              onTap: () {
                // Implemente a lógica para visualizar a pessoa
                Navigator.pop(context); // Feche o modal

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PessoaDetailPage(id: pessoa.id!);
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                // Implemente a lógica para editar a pessoa
                // Abra a tela de edição da pessoa
                Navigator.pop(context); // Feche o modal
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context); // Feche o modal
                // Implemente a lógica para excluir a pessoa
                _showDeleteConfirmationDialog(pessoa, provider);
              },
            ),
          ],
        );
      },
    );
  }
}
