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

  // Função para definir o tema com base no nome do tema
  void switchTheme(String theme) {
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
  );

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
  }

  void refreshSkinApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.getString(AppConstant.keyCor) != null) {
        switchTheme(prefs.getString(AppConstant.keyCor)!);
      }
      else{
        SkinData skinData = await ApiSkin.getSkinId(1);
        prefs.setString(AppConstant.keyCor, skinData.cor);
        prefs.setInt(AppConstant.keyIntegrador, skinData.integrador);
        prefs.setString(AppConstant.keyLogo, skinData.logo);
        prefs.setString(AppConstant.keyLogoMenu, skinData.logoMenu);
        switchTheme(skinData.cor);
      }
    } catch (error) {
      switchTheme("preto");
    }
  }
}
