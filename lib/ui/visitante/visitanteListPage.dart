import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/visitante.dart';
import '../../provider/visitante_provider.dart';
import 'CriarVisitantePage.dart';
import 'VisitorDetailPage.dart';

class VisitanteListPage extends StatefulWidget {
  const VisitanteListPage({super.key});

  @override
  createState() => _VisitanteListPageState();
}

class _VisitanteListPageState extends State<VisitanteListPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    VisitorProvider provider = context.read<VisitorProvider>();
    await provider.getList();
  }

  // Função para exibir um diálogo de confirmação
  Future<void> _showDeleteConfirmationDialog(
      Visitor visitor, VisitorProvider provider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // O diálogo não pode ser fechado tocando fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Visitante'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza de que deseja excluir este visitante?'),
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
              onPressed: () {
                // Exclua o visitante e feche o diálogo
                provider.deleteVisitor(visitor.id!);
                // Atualize a lista e notifique os ouvintes
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de visitantes'),
      ),
      body: Consumer<VisitorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            // Se os dados ainda estão sendo carregados, exiba um indicador de carregamento
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.visitors.isEmpty) {
            // Se não há visitantes, você pode exibir uma mensagem de "nenhum visitante encontrado"
            return const Center(
              child: Text('Nenhum visitante encontrado.'),
            );
          } else {
            // Caso contrário, exiba a lista de visitantes com opção de exclusão
            return ListView.builder(
              itemCount: provider.visitors.length,
              itemBuilder: (BuildContext context, int index) {
                Visitor visitor = provider.visitors[index];
                return Dismissible(
                  key: Key(
                      'visitor_${visitor.id.toString()}'), // Chave única para cada visitante
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      // Exibir o diálogo de confirmação antes de excluir
                      _showDeleteConfirmationDialog(visitor, provider);
                      //reload
                    }
                  },
                  background: Container(
                    color: Colors.red, // Cor de fundo quando arrastado
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(visitor.name!),
                    subtitle: Text(visitor.phone!),
                    onTap: () {
                      _showVisitorDetailsModal(context,
                          visitor); // Chama a função para exibir o modal
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
                  const CriarVisitantePage(), // Substitua com o nome da sua tela de criação
            ),
          );
        },
        child: const Icon(Icons.add), // Ícone de adição
      ),
    );
  }

  //dialogo de mais detalhes do visitante
  void _showVisitorDetailsModal(BuildContext context, Visitor visitor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return VisitorDetailModal(visitor: visitor);
      },
    );
  }
}
