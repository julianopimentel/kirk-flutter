import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_list.dart';
import '../provider/list_account.dart';

class ListAccountPage extends StatefulWidget {
  const ListAccountPage({Key? key}) : super(key: key);

  @override
  State<ListAccountPage> createState() => _ListAccountPageState();
}

class _ListAccountPageState extends State<ListAccountPage> {
  List<Account> userList = [];
  String searchText = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ListAccountProvider>().init();
  }

  // Implemente o método onChanged para atualizar a lista filtrada
  void onSearchTextChanged(String query) {
    setState(() {
      searchText = query;
      // Atualize a lista userList com os resultados filtrados
      userList = userList.where((account) {
        // Verifique se o nome da conta contém o texto de pesquisa, ignorando maiúsculas e minúsculas
        return account.nameConta.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar conta'),
        // Desativar o botão de voltar
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selecione uma conta:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar conta',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Expanded(
            child: Consumer<ListAccountProvider>(
              builder: (context, provider, child) {
                if (provider.accountList.isEmpty) {
                  provider.getSchema(context); // Chame a função para buscar os dados
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: provider.accountList.length,
                    itemBuilder: (context, index) {
                      Account account = provider.accountList[index];
                      return buildClickableRow(
                        context,
                        account.nameConta,
                        account.tenantId,
                        account.personId,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildClickableRow(BuildContext context, String itemName, int tenantId, int personId) {
  return InkWell(
    onTap: () {
      context.read<ListAccountProvider>().setSchema(
        tenantId: tenantId,
        personId: personId,
        nameAccount: itemName,
        context: context,
      );
    },
    child: Card(
      elevation: 2, // Elevação do card
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margem externa do card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Borda arredondada do card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.layers_outlined,
              color: Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
