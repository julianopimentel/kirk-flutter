import 'package:KirkDigital/service/theme/theme_provider.dart';
import 'package:KirkDigital/utils/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:KirkDigital/provider/account_provider.dart';
import 'package:KirkDigital/provider/list_account.dart';
import 'package:KirkDigital/provider/pessoa_provider.dart';
import 'package:KirkDigital/provider/visitante_provider.dart';
import 'ui/screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ListAccountProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
        ChangeNotifierProvider(create: (_) => PessoaProvider())
      ],
      child: MaterialApp(
        theme: _buildThemeData(themeProvider),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildThemeData(ThemeProvider themeProvider) {
    return ThemeData(
      primaryColor: themeProvider.currentTheme.primaryColor,
      iconTheme: IconThemeData(
        color: themeProvider.currentTheme.iconColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: themeProvider.currentTheme.primaryColor,
        iconTheme: IconThemeData(
          color: themeProvider.currentTheme.iconColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeProvider.currentTheme.primaryColor,
        foregroundColor: themeProvider.currentTheme.iconColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: themeProvider.currentTheme.primaryColor,
          onPrimary: themeProvider.currentTheme.iconColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: themeProvider.currentTheme.primaryColor,
          onSurface: themeProvider.currentTheme.iconColor,
        ),
      ),
    );
  }
}

/*

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Crie canais de notificação no Android
  _createNotificationChannels();
  // Inicialize o Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  // Configure a cor da barra de status
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

// Função para manipular mensagens em segundo plano
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // Crie uma instância do plugin FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Crie uma instância do AndroidNotificationDetails
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'meu_canal_padrao',
      'Canal Padrão',
      importance: Importance.max,
      icon: '@mipmap/ic_launcher'
  );

  // Crie uma instância do NotificationDetails
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  final int notificacaoId = message.data['id'].hashCode;
  // Gere um ID de notificação único
  // Exiba a notificação
  await flutterLocalNotificationsPlugin.show(
    notificacaoId,
    message.data['title'],
    message.data['message'],
    platformChannelSpecifics,
    payload: message.data['payload'],
  );

}

// Função para criar canais de notificação no Android
void _createNotificationChannels() {
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'meu_canal_padrao',
      'Canal Padrão',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

void setStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.grey, // Cor da barra de status
    statusBarBrightness: Brightness.light, // Brilho do texto da barra de status
    statusBarIconBrightness: Brightness.light, // Cor dos ícones da barra de status (por exemplo, ícone de bateria)
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.refreshSkinApi();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ListAccountProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
        ChangeNotifierProvider(create: (_) => PessoaProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: themeProvider.currentTheme.primaryColor,
          iconTheme: IconThemeData(
            color: themeProvider.currentTheme.iconColor,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: themeProvider.currentTheme.primaryColor,
            iconTheme: IconThemeData(
              color: themeProvider.currentTheme.iconColor,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: themeProvider.currentTheme.primaryColor,
            foregroundColor: themeProvider.currentTheme.iconColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: themeProvider.currentTheme.primaryColor,
              onPrimary: themeProvider.currentTheme.iconColor,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              primary: themeProvider.currentTheme.primaryColor,
              onSurface: themeProvider.currentTheme.iconColor,
            ),
          ),
        ),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

*/