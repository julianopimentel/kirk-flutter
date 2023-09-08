import 'package:KirkDigital/provider/account_provider.dart';
import 'package:KirkDigital/provider/list_account.dart';
import 'package:KirkDigital/provider/pessoa_provider.dart';
import 'package:KirkDigital/provider/visitante_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/splash/splash_page.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ListAccountProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
        ChangeNotifierProvider(create: (_) => PessoaProvider())
      ],
      child: const MaterialApp(
        home: SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
