import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../common/app_constant.dart';
import '../../common/cliente_constant.dart';

import 'api_skin_data.dart';
import 'app_theme.dart';


class ThemeProvider extends ChangeNotifier {
  // Variáveis para armazenar as cores do tema
  String themeName = "";
  Color primaryColor = Colors.blueGrey.shade900;
  Color accentColor = Colors.grey.shade700;
  Color iconColor = Colors.white;
  Color statusBarColor = Colors.blueGrey.shade900;
  String logo = "";
  String logoMenu = "";

  // Função para definir o tema com base no nome do tema
  AppTheme switchTheme(String theme, String logo, String logoMenu) {
    switch (theme) {
      case "preto":
        themeName = "preto";
        primaryColor = Colors.blueGrey.shade900;
        accentColor = Colors.grey.shade700;
        statusBarColor = Colors.blueGrey.shade900;
        break;
      case "azul":
        themeName = "azul";
        primaryColor = Colors.blue.shade900;
        accentColor = Colors.blue.shade700;
        statusBarColor = Colors.blue.shade900;
        break;
      case "vermelho":
        themeName = "vermelho";
        primaryColor = Colors.red.shade900;
        accentColor = Colors.red.shade700;
        statusBarColor = Colors.red.shade900;
        break;
      case "verde":
        themeName = "verde";
        primaryColor = Colors.green.shade900;
        accentColor = Colors.green.shade700;
        statusBarColor = Colors.green.shade900;
        break;
      case "amarelo":
        themeName = "amarelo";
        primaryColor = Colors.yellow.shade900;
        accentColor = Colors.yellow.shade700;
        statusBarColor = Colors.yellow.shade900;
        break;
      case "laranja":
        themeName = "laranja";
        primaryColor = Colors.orange.shade900;
        accentColor = Colors.orange.shade700;
        statusBarColor = Colors.orange.shade900;
        break;
      case "rosa":
        themeName = "rosa";
        primaryColor = Colors.pink.shade900;
        accentColor = Colors.pink.shade700;
        statusBarColor = Colors.pink.shade900;
        break;
      case "violeta":
        themeName = "violeta";
        primaryColor = Colors.purple.shade900;
        accentColor = Colors.purple.shade700;
        statusBarColor = Colors.purple.shade900;
        break;
      case "marrom":
        themeName = "marrom";
        primaryColor = Colors.brown.shade900;
        accentColor = Colors.brown.shade700;
        statusBarColor = Colors.brown.shade900;
        break;
      case "cinza":
        themeName = "cinza";
        primaryColor = Colors.grey.shade900;
        accentColor = Colors.grey.shade700;
        statusBarColor = Colors.grey.shade900;
        break;
      case "azul claro":
        themeName = "azul claro";
        primaryColor = Colors.lightBlue.shade900;
        accentColor = Colors.lightBlue.shade700;
        statusBarColor = Colors.lightBlue.shade900;
        break;
      case "verde-claro":
        themeName = "verde-claro";
        primaryColor = Colors.lightGreen.shade900;
        accentColor = Colors.lightGreen.shade700;
        statusBarColor = Colors.lightGreen.shade900;
        break;
      case "vermelho-claro":
        themeName = "vermelho-claro";
        primaryColor = Colors.red.shade900;
        primaryColor = Colors.red.shade500;
        accentColor = Colors.red.shade300;
        statusBarColor = Colors.red.shade500;
        break;
      default:
        // Caso nenhum tema corresponda, você pode definir um tema padrão
        themeName = "preto";
        break;
    }
    if (kDebugMode) {
      print("themeName: $themeName");
    }
    return AppTheme(
      themeName: themeName,
      primaryColor: primaryColor,
      accentColor: accentColor,
      iconColor: iconColor,
      statusBarColor: statusBarColor,
      logo: logo,
      logoMenu: logoMenu,
    );
  }

  AppTheme _currentTheme = AppTheme(
    themeName: ClienteConstant.appCor,
    primaryColor: Colors.blueGrey.shade900,
    accentColor: Colors.grey.shade700,
    iconColor: Colors.white,
    statusBarColor: Colors.blueGrey.shade900,
    logo: '',
    logoMenu: '',
  );


  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
  }

  void aplicaThema(String appCor) {
    AppTheme newTheme = switchTheme(
        _currentTheme.themeName, _currentTheme.logo, _currentTheme.logoMenu);
    setTheme(newTheme);
  }

  AppTheme getTheme() {
    return _currentTheme;
  }

  //funcao para tratar a imagem do logo
  Image getLogoImage({bool isLess = false}) {
    String logoBase64 = _currentTheme.logo;
    Image? logoImage;

    double height = 200;
    double width = 200;
    //se for para o menu, a imagem é menor
    if (isLess) {
      height = 100;
      width = 100;
    }
    if (logoBase64.isNotEmpty) {
      List<int> decodedBytes = base64Decode(logoBase64);
      Uint8List bytes = Uint8List.fromList(decodedBytes);
      logoImage =
          Image.memory(
              bytes, fit: BoxFit.contain, height: height, width: width);
    } else {
      // Se não houver uma representação válida em base64, carrega a imagem dos assets
      logoImage = Image.asset(ClienteConstant.appLogo, fit: BoxFit.contain,
          height: height,
          width: width);
    }
    return logoImage;
  }

  //funcao para tratar a imagem do logo
  Image getLogoMenuImage() {
    String logoBase64 = _currentTheme.logoMenu;
    Image? logoImage;

    //tamanho da imagem quando é para o login ou quando for para o menu
    double height = 80;
    double width = 200;
    //se for para o menu, a imagem é menor
    if (logoBase64.isNotEmpty) {
      List<int> decodedBytes = base64Decode(logoBase64);
      Uint8List bytes = Uint8List.fromList(decodedBytes);
      logoImage =
          Image.memory(
              bytes, fit: BoxFit.contain, height: height, width: width);
    } else {
      // Se não houver uma representação válida em base64, carrega a imagem dos assets
      logoImage = Image.asset(ClienteConstant.appLogoMenu, fit: BoxFit.contain,
          height: height,
          width: width);
    }
    return logoImage;
  }

  Future<void> refreshSkinApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String? cor = prefs.getString(AppConstant.keyCor);
      String? logo = prefs.getString(AppConstant.keyLogo);
      String? logoMenu = prefs.getString(AppConstant.keyLogoMenu);

      if (cor != null && logo != null && logoMenu != null) {
        AppTheme newTheme = switchTheme(cor, logo, logoMenu);
        setTheme(newTheme);
      } else {
        await fetchAndSetDefaultSkin();
      }
      notifyListeners();
    } catch (error) {
      await fetchAndSetDefaultSkin();
    }
  }

  Future<void> fetchAndSetDefaultSkin() async {
    try {
      SkinData skinData = await ApiSkinData.getSkinId(ClienteConstant.appIntegrador);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(AppConstant.keyCor, skinData.cor);
      prefs.setInt(AppConstant.keyIntegrador, skinData.integrador);
      prefs.setString(AppConstant.keyLogo, skinData.logo);
      prefs.setString(AppConstant.keyLogoMenu, skinData.logoMenu);

      AppTheme newTheme = switchTheme(skinData.cor, skinData.logo, skinData.logoMenu);
      setTheme(newTheme);
    } catch (error) {
      aplicaThema(ClienteConstant.appCor);
      notifyListeners();
    }
    notifyListeners();
  }
}