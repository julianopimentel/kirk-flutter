import 'package:flutter/material.dart';

import '../AppTheme.dart';


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
        iconColor = Colors.white;
        statusBarColor = Colors.blueGrey.shade900;
        break;
      case "azul":
        primaryColor = Colors.blue.shade900;
        accentColor = Colors.blue.shade700;
        iconColor = Colors.white;
        statusBarColor = Colors.blue.shade900;
        break;
      case "red":
        primaryColor = Colors.red.shade900;
        accentColor = Colors.red.shade700;
        iconColor = Colors.white;
        statusBarColor = Colors.red.shade900;
        break;
    // Adicione mais casos conforme necessário para outros temas
      default:
      // Caso nenhum tema corresponda, você pode definir um tema padrão
        primaryColor = Colors.blueGrey.shade900;
        accentColor = Colors.grey.shade700;
        iconColor = Colors.white;
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
  }
