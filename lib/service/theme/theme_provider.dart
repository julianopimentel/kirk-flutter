import 'dart:convert';
import 'dart:typed_data';

import 'package:KirkDigital/common/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:KirkDigital/service/theme/api_skin.dart';
import 'package:KirkDigital/service/theme/app_theme.dart';


class ThemeProvider extends ChangeNotifier {
  // Variáveis para armazenar as cores do tema
  Color primaryColor = Colors.blueGrey.shade900;
  Color accentColor = Colors.grey.shade700;
  Color iconColor = Colors.white;
  Color statusBarColor = Colors.blueGrey.shade900;
  String logo = "";
  String logoMenu = "";

  // Função para definir o tema com base no nome do tema
  void switchTheme(String theme, String logo, String logoMenu) {
    switch (theme) {
      case "preto":
        primaryColor = Colors.blueGrey.shade900;
        accentColor = Colors.grey.shade700;
        statusBarColor = Colors.blueGrey.shade900;
        break;
      case "azul":
        primaryColor = Colors.blue.shade900;
        accentColor = Colors.blue.shade700;
        statusBarColor = Colors.blue.shade900;
        break;
      case "vermelho":
        primaryColor = Colors.red.shade900;
        accentColor = Colors.red.shade700;
        statusBarColor = Colors.red.shade900;
        break;
      case "verde":
        primaryColor = Colors.green.shade900;
        accentColor = Colors.green.shade700;
        statusBarColor = Colors.green.shade900;
        break;
      case "amarelo":
        primaryColor = Colors.yellow.shade900;
        accentColor = Colors.yellow.shade700;
        statusBarColor = Colors.yellow.shade900;
        break;
      case "laranja":
        primaryColor = Colors.orange.shade900;
        accentColor = Colors.orange.shade700;
        statusBarColor = Colors.orange.shade900;
        break;
      case "rosa":
        primaryColor = Colors.pink.shade900;
        accentColor = Colors.pink.shade700;
        statusBarColor = Colors.pink.shade900;
        break;
      case "violeta":
        primaryColor = Colors.purple.shade900;
        accentColor = Colors.purple.shade700;
        statusBarColor = Colors.purple.shade900;
        break;
      case "marrom":
        primaryColor = Colors.brown.shade900;
        accentColor = Colors.brown.shade700;
        statusBarColor = Colors.brown.shade900;
        break;
      case "cinza":
        primaryColor = Colors.grey.shade900;
        accentColor = Colors.grey.shade700;
        statusBarColor = Colors.grey.shade900;
        break;
      case "azul claro":
        primaryColor = Colors.lightBlue.shade900;
        accentColor = Colors.lightBlue.shade700;
        statusBarColor = Colors.lightBlue.shade900;
        break;
      case "verde-claro":
        primaryColor = Colors.lightGreen.shade900;
        accentColor = Colors.lightGreen.shade700;
        statusBarColor = Colors.lightGreen.shade900;
        break;
      case "vermelho-claro":
        primaryColor = Colors.red.shade500;
        accentColor = Colors.red.shade300;
        statusBarColor = Colors.red.shade500;
        break;
      default:
      // Caso nenhum tema corresponda, você pode definir um tema padrão
        primaryColor = Colors.blueGrey.shade900;
        accentColor = Colors.grey.shade700;
        statusBarColor = Colors.blueGrey.shade900;
        break;
    }

    // Crie um objeto AppTheme com base nas cores do tema
    AppTheme currentTheme = AppTheme(
      primaryColor: primaryColor,
      accentColor: accentColor,
      iconColor: iconColor,
      statusBarColor: statusBarColor,
      logo: logo,
      logoMenu: logoMenu,
    );

    setTheme(currentTheme);
    _currentTheme = currentTheme;

    print("Tema alterado para: $theme");

  }

  AppTheme _currentTheme = AppTheme(
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

  void refreshSkinApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getString(AppConstant.keyCor) != null) {
        String cor = prefs.getString(AppConstant.keyCor)!;
        String logo = prefs.getString(AppConstant.keyLogo)!;
        String logoMenu = prefs.getString(AppConstant.keyLogoMenu)!;
        switchTheme(cor, logo, logoMenu);
      }
      else{
        SkinData skinData = await ApiSkin.getSkinId(1);
        prefs.setString(AppConstant.keyCor, skinData.cor);
        prefs.setInt(AppConstant.keyIntegrador, skinData.integrador);
        prefs.setString(AppConstant.keyLogo, skinData.logo);
        prefs.setString(AppConstant.keyLogoMenu, skinData.logoMenu);
        switchTheme(skinData.cor, skinData.logo, skinData.logoMenu);
        notifyListeners();
      }
    } catch (error) {
      switchTheme("preto", '', '');
    }
  }

  //funcao para tratar a imagem do logo
  Image getLogoImage({bool isLess = false}) {
    String logoBase64 = _currentTheme.logo ?? '';
    Image? logoImage;

    //tamanho da imagem quando é para o login ou quando for para o menu
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
      logoImage = Image.memory(bytes, fit: BoxFit.contain, height: height, width: width);
    } else {
      // Se não houver uma representação válida em base64, carrega a imagem dos assets
      logoImage = Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: height, width: width);
    }
    return logoImage;
  }

  //funcao para tratar a imagem do logo
  Image getLogoMenuImage() {
    String logoBase64 = _currentTheme.logoMenu ?? '';
    Image? logoImage;

    //tamanho da imagem quando é para o login ou quando for para o menu
    double height = 80;
    double width = 200;
    //se for para o menu, a imagem é menor
    if (logoBase64.isNotEmpty) {
      List<int> decodedBytes = base64Decode(logoBase64);
      Uint8List bytes = Uint8List.fromList(decodedBytes);
      logoImage = Image.memory(bytes, fit: BoxFit.contain, height: height, width: width);
    } else {
      // Se não houver uma representação válida em base64, carrega a imagem dos assets
      logoImage = Image.asset('assets/images/logoMenu.png', fit: BoxFit.contain, height: height, width: width);
    }
    return logoImage;
  }

}
