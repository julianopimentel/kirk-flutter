import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/account_provider.dart';
import '../../service/theme/theme_provider.dart';
import '../ListAccountPage.dart';
import '../auth/login.dart';
import '../home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _initData() async {
    AccountProvider provider = context.read<AccountProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);


    await provider.init();
    await themeProvider.refreshSkinApi();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          if(provider.token == null) {
            return const LoginPage();
          }
          else if (provider.token != null && provider.userInstance == null) {
            return const ListAccountPage();
          }
          else if (provider.token != null && provider.userInstance != null) {
            return const HomePage();
          }
          else {
            return const LoginPage();
          }
          //return provider.token == null ? const LoginPage() : const ListAccountPage();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }


  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}