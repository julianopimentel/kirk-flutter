import 'dart:convert';

import 'package:KirkDigital/model/person_me.dart';
import 'package:KirkDigital/ui/componentes/foto_field.dart';
import 'package:KirkDigital/ui/pessoa/CriarPessoaPage.dart';
import 'package:KirkDigital/ui/pessoa/ListPage.dart';
import 'package:KirkDigital/ui/visitante/CriarVisitantePage.dart';
import 'package:KirkDigital/ui/visitante/visitanteListPage.dart';
import 'package:KirkDigital/ui/oferta/EnviarOfertaPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/app_constant.dart';
import '../model/permission.dart';
import '../provider/account_provider.dart';
import '../service/notification_service.dart';
import 'ListAccountPage.dart';
import 'UserProfilePage.dart';
import 'auth/login.dart';
import 'componentes/fotoNova_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double availableScreenWidth = 0;
  int selectedIndex = 0;
  String nomeDaConta = 'Igreja Demo';
  String get nameConta => nomeDaConta;
  late List<Permission> permissions = [];
  bool showMultiAccounts = false;
  PersonMe personMe = PersonMe(); // Inicialize com um objeto vazio

  @override
  void initState() {
    super.initState();
    _loadSavedValues();

  }



  Future<void> _loadSavedValues() async {
    personMe = await context.read<AccountProvider>().getDadosPessoais();

    SharedPreferences prefs = await SharedPreferences.getInstance();

      nomeDaConta = prefs.getString('name_conta')!;
      showMultiAccounts = prefs.getBool('keyMultiConta')!;
      // Verifique se a chave 'permissions' existe
      String? permissionsJson = prefs.getString(AppConstant.keyPermission);

      if (permissionsJson != null) {
        // Decodifique o JSON para uma lista de permissões
        permissions = Permission.permissionsFromJson(json.decode(permissionsJson));
      }
      else{
        //retornar para a tela de listagem de contas
        NotificationService.showNotification('Você não possui permissão para acessar o sistema, verifique com o administrador!', NotificationType.error, context);
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ListAccountPage();
            },
          ),
        );
      }

      setState(() {
      });

  }

  List<MenuItem> buildMenuItems(List<Permission> permissions) {
    List<MenuItem> menuItems = [];

    if (permissions.any((permission) => permission.features == 'DASHBOARD' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.dashboard_outlined
          , 'Dashboard', route: 'dashboardPage'));
    }

    if (permissions.any((permission) => permission.features == 'PERSON' && permission.criar == true)) {
      menuItems.add(MenuItem(Icons.person, 'Pessoas', route: 'PessoaListPage'));
    }

    if (permissions.any((permission) => permission.features == 'PERSON' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.group_outlined, 'Grupo Familiar', route: 'personPage'));
    }
    if (permissions.any((permission) => permission.features == 'PREPERSON' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.perm_contact_calendar_outlined, 'Visitantes' , route: 'visitanteListPage()'));
    }

    if (permissions.any((permission) => permission.features == 'MESSAGE' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.messenger_outline, 'Mensagens', route: 'messagePage'));
    }

    if (permissions.any((permission) => permission.features == 'HOME_FINANCIAL' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.monetization_on_outlined, 'Meus dizimos', route: 'homeFinancialPage'));
    }

    if (permissions.any((permission) => permission.features == 'FINANCIAL' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.qr_code_outlined, 'Enviar Oferta', route: 'EnviarOfertaPage'));
    }

    if (permissions.any((permission) => permission.features == 'PRAYER' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.support_agent_outlined, 'Pedir Oração', route: 'prayerPage'));
    }

    if (permissions.any((permission) => permission.features == 'HOME_EVENT' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.event_outlined, 'Eventos', route: 'homeEventPage'));
    }

    menuItems.add(MenuItem(Icons.location_history, 'Meus dados', route: 'meusDadosPage'));
    menuItems.add(MenuItem(Icons.add_location_outlined, 'Endereço', route: 'enderecoPage'));

    if (permissions.any((permissions ) => permissions.features == 'HOME_SOCIAL' && permissions.ler == true)) {
      menuItems.add(MenuItem(Icons.data_exploration_outlined, 'Rede Social', route: 'homeSocialPage'));
    }

    // Continue adicionando itens com base nas permissões
    return menuItems;
  }

  Widget buildHeaderText(String nameConta) {
    return Text(
      nameConta ?? '',
      style: TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<AccountProvider>().logout();
    NotificationService.showNotification('Logout realizado com sucesso!', NotificationType.success, context);


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return const LoginPage();
      }),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
            alignment: Alignment.bottomCenter,
            height: 180,
            decoration: BoxDecoration(color: Colors.blue.shade800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0), // Adicione o espaço horizontal aqui
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FotoNovaField(
                        imageUrl: personMe.image,
                        name: personMe.name,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olá, ${personMe.name}" ?? '',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    buildHeaderText(nameConta),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    if (showMultiAccounts)
                      buildIconButton(Icons.sync_alt_outlined, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ListAccountPage();
                            },
                          ),
                        );
                      }),
                    const SizedBox(width: 10),
                    buildIconButton(
                      Icons.logout,
                          () => showDialog(
                        context: context,
                        builder: _dialog,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    buildMenu(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
        ]),
        child: FloatingActionButton(
          onPressed: () {
            _mostrarMenuOpcoes(context);
            },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) => UserProfilePage(),
              ));
            }
          });
        },
        currentIndex: selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_outlined),
            label: 'Meus dados',
          ),
        ],
      ),
    );
  }

  Widget buildIconButton(IconData iconData, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(.1),
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          size: 12,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget buildMenuRow(List<MenuItem> menuItems) {
    return Row(
      children: menuItems
          .map((menuItem) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: buildMenuColumn(menuItem , context),
              ))
          .toList(),
    );
  }

  Widget buildMenuColumn(MenuItem menuItem, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Verifique se a rota está definida no MenuItem
        if (menuItem.route != null) {
          // Navegue para a rota especificada
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
            if(menuItem.route == 'visitanteListPage()'){
              return VisitanteListPage();
            }
            if(menuItem.route == 'personPage'){
              return UserProfilePage();
            }
            if(menuItem.route == 'PessoaListPage'){
              return PessoaListPage();
            }
            if(menuItem.route == 'EnviarOfertaPage'){
              return EnviarOfertaPage();
            }
            return UserProfilePage();

          }));
        }
      },
      child: Column(
        children: [
          Container(
            width: availableScreenWidth * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  menuItem.iconData,
                  size: 30,
                  color: Colors.blue.shade800,
                ),
                const SizedBox(height: 10),
                Text(
                  menuItem.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget buildMenu() {
    // Verifique se as permissões foram carregadas
    if (permissions == null) {
      return CircularProgressIndicator(); // Ou qualquer outro indicador de carregamento
    }
    // Divida a lista de permissões em grupos de 2
    List<List<Permission>> permissionGroups = [];
    List<MenuItem> menuItems = buildMenuItems(permissions);
    List<Widget> menuRows = [];
    List<MenuItem> currentRow = [];
    for (final menuItem in menuItems) {
      currentRow.add(menuItem);
      if (currentRow.length == 2) { // Quebre a linha após o segundo item
        menuRows.add(buildMenuRow(currentRow));
        currentRow = [];
      }
    }
    if (currentRow.isNotEmpty) {
      menuRows.add(buildMenuRow(currentRow));
    }
    return Column(
      children: menuRows,
    );
  }

  double calculateRowWidth(List<MenuItem> rowItems) {
    // Implemente a lógica para calcular a largura da linha com base nos MenuItem
    double yourMenuItemWidth = 60;
    return rowItems.length * yourMenuItemWidth;
  }

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      content: const Text('Deseja realmente sair?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => _logout(context),
          child: const Text('SAIR'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCELAR'),
        ),
      ],
    );
  }

  void _mostrarMenuOpcoes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Personalize o conteúdo do modal aqui
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Visitante'),
                onTap: () {
                  // Adicione a lógica para adicionar visitante aqui
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                    return CriarVisitantePage();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add_alt_1_outlined),
                title: Text('Pessoa'),
                onTap: () {
                  // Adicione a lógica para adicionar pessoa aqui
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                    return CriarPersonPage();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet_outlined),
                title: Text('Oferta'),
                onTap: () {
                  // Adicione a lógica para enviar oferta aqui
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
                    return UserProfilePage();
                  }));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class MenuItem {
  final IconData iconData;
  final String title;
  final String? route;

  MenuItem(this.iconData, this.title, {this.route});
}
