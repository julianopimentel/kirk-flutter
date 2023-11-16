
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kirkdigital/provider/account_provider.dart';
import 'package:kirkdigital/provider/list_account.dart';
import 'package:kirkdigital/provider/pessoa_provider.dart';
import 'package:kirkdigital/provider/visitante_provider.dart';
import 'package:kirkdigital/service/theme/theme_provider.dart';
import 'package:kirkdigital/utils/firebase/firebase_options.dart';
import 'package:kirkdigital/utils/system_utils.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'ui/screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    initializeApp();
  }

  // Sentry SDK
  await SentryFlutter.init(
          (options) {
        options.dsn = 'https://052ea8023785ac8a0f01b92857fc16f3@o1292892.ingest.sentry.io/4506232232869888';
        options.tracesSampleRate = 1.0;
        options.tracesSampler = (samplingContext) {
          if (samplingContext.transactionContext?.name?.contains('slow') == true) {
            return 1.0;
          }
          return 0.0;
        };
      },
      appRunner: () => runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
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
          foregroundColor: themeProvider.currentTheme.iconColor, backgroundColor: themeProvider.currentTheme.primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: themeProvider.currentTheme.primaryColor, disabledForegroundColor: themeProvider.currentTheme.iconColor.withOpacity(0.38),
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