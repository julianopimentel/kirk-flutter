import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/app_constant.dart';
import '../../model/permission.dart';
import '../../model/person_me.dart';
import '../../provider/account_provider.dart';
import '../../service/theme/theme_provider.dart';
import '../../utils/toastr_utils.dart';
import '../account/list_account_page.dart';
import '../oferta/enviar_oferta_page.dart';
import '../pessoa/pessoa_create_page.dart';
import '../pessoa/pessoa_list_page.dart';
import '../profile/user_profile_page.dart';
import '../auth/login.dart';
import '../componentes/foto_field.dart';
import '../visitante/create_visitant_page.dart';
import '../visitante/visitante_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double availableScreenWidth = 0;
  int selectedIndex = 0;
  String nomeDaConta = '';

  String get nameConta => nomeDaConta;
  late List<Permission> permissions = [];
  bool showMultiAccounts = false;
  PersonMe personMe = PersonMe(); // Inicialize com um objeto vazio
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }



  Future<void> _loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    personMe = await context.read<AccountProvider>().getDadosPessoais(context);
    if(personMe == null){
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
      );
    }
    nomeDaConta = prefs.getString(AppConstant.keyNameConta) ?? '';
    showMultiAccounts = prefs.getBool('keyMultiConta')!;
    // Verifique se a chave 'permissions' existe
    String? permissionsJson = prefs.getString(AppConstant.keyPermission);

    if (permissionsJson != null) {
      // Decodifique o JSON para uma lista de permissões
      permissions = Permission.permissionsFromJson(json.decode(permissionsJson));
    } else {
      //retornar para a tela de listagem de contas
      _returnListaAccount();
    }

    setState(() {
      isLoading = false;
    });
  }

  _returnListaAccount() {
    NotificationUtils.showWarning(context,
        'Você não possui permissão para acessar o sistema, verifique com o administrador!');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const ListAccountPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return !isLoading
        ? Scaffold(
            backgroundColor: Colors.grey[100],
            body: Column(
              children: [
                // Logo Section
                Container(
                  padding: const EdgeInsets.only(top: 35, left: 10, right: 10),
                  alignment: Alignment.center,
                  height: 80,
                  // Ajuste conforme necessário
                  decoration: BoxDecoration(
                      color: themeProvider.currentTheme.primaryColor),
                  child: themeProvider.getLogoMenuImage(),
                ),
                // Header Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
                  alignment: Alignment.bottomCenter,
                  height: 110,
                  decoration: BoxDecoration(
                      color: themeProvider.currentTheme.primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        // Adicione o espaço horizontal aqui
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FotoField(
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
                            personMe.name!.split(' ')[0],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          buildHeaderText(
                              nameConta, context, showMultiAccounts),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (showMultiAccounts)
                            buildIconButton(Icons.sync_alt_outlined, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const ListAccountPage();
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
                ),
              ],
            ),
            floatingActionButton: Container(
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
              ]),
              child: FloatingActionButton(
                onPressed: () {
                  _mostrarMenuOpcoes(context);
                },
                backgroundColor: themeProvider.currentTheme.accentColor,
                child: const Icon(Icons.add),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                  if (index == 1) {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => const UserProfilePage(),
                    ));
                  }
                });
              },
              currentIndex: selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined,
                      color: themeProvider.currentTheme.primaryColor, size: 30),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_3_outlined,
                      color: themeProvider.currentTheme.primaryColor, size: 30),
                  label: 'Meus dados',
                ),
              ],
            ),
          )
        : buildShimmerContent(context);
  }

  Widget buildShimmerContent(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Cor de fundo
        highlightColor: Colors.grey[100]!, // Cor do brilho
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 22),
              alignment: Alignment.bottomCenter,
              height: 180,
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
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
            ),
          ],
        ),
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
                child: buildMenuColumn(menuItem, context),
              ))
          .toList(),
    );
  }

  Widget buildMenuColumn(MenuItem menuItem, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        // Verifique se a rota está definida no MenuItem
        if (menuItem.route != null) {
          // Navegue para a rota especificada
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            if (menuItem.route == 'visitanteListPage()') {
              return const VisitanteListPage();
            }
            if (menuItem.route == 'personPage') {
              return const UserProfilePage();
            }
            if (menuItem.route == 'PessoaListPage') {
              return const PessoaListPage();
            }
            if (menuItem.route == 'EnviarOfertaPage') {
              return const EnviarOfertaPage();
            }
            return const UserProfilePage();
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
                  color: themeProvider.currentTheme.primaryColor,
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
    // Divida a lista de permissões em grupos de 2
    List<MenuItem> menuItems = buildMenuItems(permissions);
    List<Widget> menuRows = [];
    List<MenuItem> currentRow = [];
    for (final menuItem in menuItems) {
      currentRow.add(menuItem);
      if (currentRow.length == 2) {
        // Quebre a linha após o segundo item
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

  double calculateMaxTextLength(BuildContext context, bool showMultiAccounts) {
    // Obtém a largura total da tela
    double screenWidth = MediaQuery.of(context).size.width;

    // Defina uma margem segura e espaço para os ícones
    double safeMargin = 35.0; // ou o valor que você preferir
    double iconSpace =
        showMultiAccounts ? 40.0 : 1.0; // ajuste conforme necessário

    // Calcule o tamanho máximo para o texto
    double maxTextWidth = screenWidth - safeMargin - iconSpace;

    // Defina um tamanho máximo de caracteres com base no tamanho da fonte e do estilo
    TextStyle textStyle =
        const TextStyle(fontSize: 12); // ajuste conforme necessário
    double maxTextLength = maxTextWidth / textStyle.fontSize!;

    return maxTextLength.floorToDouble();
  }

  List<MenuItem> buildMenuItems(List<Permission> permissions) {
    List<MenuItem> menuItems = [];

    if (permissions.any((permission) =>
        permission.features == 'DASHBOARD' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.dashboard_outlined, 'Dashboard',
          route: 'dashboardPage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'PERSON' && permission.criar == true)) {
      menuItems.add(MenuItem(Icons.person, 'Pessoas', route: 'PessoaListPage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'PERSON' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.group_outlined, 'Grupo Familiar',
          route: 'personPage'));
    }
    if (permissions.any((permission) =>
        permission.features == 'PREPERSON' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.perm_contact_calendar_outlined, 'Visitantes',
          route: 'visitanteListPage()'));
    }

    if (permissions.any((permission) =>
        permission.features == 'MESSAGE' && permission.ler == true)) {
      menuItems.add(
          MenuItem(Icons.messenger_outline, 'Mensagens', route: 'messagePage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'HOME_FINANCIAL' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.monetization_on_outlined, 'Meus dizimos',
          route: 'homeFinancialPage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'FINANCIAL' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.qr_code_outlined, 'Enviar Oferta',
          route: 'EnviarOfertaPage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'PRAYER' && permission.ler == true)) {
      menuItems.add(MenuItem(Icons.support_agent_outlined, 'Pedir Oração',
          route: 'prayerPage'));
    }

    if (permissions.any((permission) =>
        permission.features == 'HOME_EVENT' && permission.ler == true)) {
      menuItems.add(
          MenuItem(Icons.event_outlined, 'Eventos', route: 'homeEventPage'));
    }

    menuItems.add(MenuItem(Icons.location_history, 'Meus dados', route: 'meusDadosPage'));
    menuItems.add(MenuItem(Icons.add_location_outlined, 'Endereço', route: 'enderecoPage'));
    // Continue adicionando itens com base nas permissões
    return menuItems;
  }

  Widget buildHeaderText(
      String nameConta, BuildContext context, bool showMultiAccounts) {
    double maxTextLength = calculateMaxTextLength(context, showMultiAccounts);

    return Text(
      nameConta.length > maxTextLength
          ? '${nameConta.substring(0, maxTextLength.toInt())}...'
          : nameConta,
      style: const TextStyle(fontSize: 12, color: Colors.white),
      overflow: TextOverflow.ellipsis,
    );
  }

  _logout(BuildContext context) async {
    Navigator.pop(context);

    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      title: Text("Aguarde..."),
      message: Text("Saindo da conta..."),
    );
    progressDialog.show();

    await context.read<AccountProvider>().logout();
    NotificationUtils.showSuccess(context, 'Logout realizado com sucesso!');

    progressDialog.dismiss();
    _returnLogin();
  }

  _returnLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return const LoginPage();
    }));
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Visitante'),
              onTap: () {
                // Adicione a lógica para adicionar visitante aqui
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return const CreateVisitPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: const Text('Pessoa'),
              onTap: () {
                // Adicione a lógica para adicionar pessoa aqui
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return const PessoaCreatePage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Oferta'),
              onTap: () {
                // Adicione a lógica para enviar oferta aqui
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return const UserProfilePage();
                }));
              },
            ),
          ],
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
