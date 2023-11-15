import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/account_provider.dart';
import '../../service/theme/theme_provider.dart';
import '../account/list_account_page.dart';
import '../auth/login.dart';
import '../home/home.dart';
import 'onboarding_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _completer = Completer<void>();

    // Adie a execução do código assíncrono usando Future.delayed
    Future.delayed(Duration.zero, () {
      _initData(context);
    });
  }

  Future<void> _initData(BuildContext context) async {
    AccountProvider provider = context.read<AccountProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    await provider.init();
    await themeProvider.refreshSkinApi();

    // Navegue para a próxima tela com base no estado do token
    if (provider.token == null && provider.isFistLogin == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } else if (provider.token != null && provider.userInstance == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ListAccountPage()));
    } else if (provider.token != null && provider.userInstance != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    }

    // Complete o Future quando a navegação estiver concluída
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _completer.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        } else {
          return Container(); // ou qualquer outro indicador de carregamento que você preferir
        }
      },
    );
  }
}
