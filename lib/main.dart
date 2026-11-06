import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/notificacao_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const AlertaTiApp());

  // Depois do runApp, para o Navigator já existir quando uma notificação
  // tocada precisar abrir a tela de detalhes.
  NotificacaoService.init();
}

class AlertaTiApp extends StatelessWidget {
  const AlertaTiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta TI',
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificacaoService.navigatorKey,
      scaffoldMessengerKey: NotificacaoService.messengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
