import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../firebase_options.dart';
import '../models/incidente.dart';
import '../screens/detalhe_incidente_screen.dart';

/// Handler de mensagens com o app em segundo plano / fechado.
/// Precisa ser função de nível superior. Para mensagens do tipo "notificação"
/// (as enviadas pelo Firebase Console) o Android já exibe o aviso sozinho;
/// este handler existe para a mensagem poder ser processada se necessário.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] mensagem em segundo plano: ${message.messageId}');
}

class NotificacaoService {
  NotificacaoService._();

  /// Chave global para navegar a partir de callbacks de notificação.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Chave para exibir avisos internos quando o app está aberto.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Token FCM do aparelho (mostrado na tela inicial para facilitar o teste).
  static final ValueNotifier<String?> token = ValueNotifier<String?>(null);

  static Future<void> init() async {
    final fcm = FirebaseMessaging.instance;

    // Android 13+ exige permissão em tempo de execução.
    final permissao = await fcm.requestPermission();
    debugPrint('[FCM] permissão: ${permissao.authorizationStatus}');

    token.value = await fcm.getToken();
    debugPrint('[FCM] token: ${token.value}');
    fcm.onTokenRefresh.listen((novo) => token.value = novo);

    // App ABERTO (primeiro plano): o Android não mostra a notificação
    // automaticamente, então exibimos um aviso interno com ação "Ver".
    FirebaseMessaging.onMessage.listen(_aoReceberComAppAberto);

    // App em SEGUNDO PLANO e usuário tocou na notificação.
    FirebaseMessaging.onMessageOpenedApp.listen(_abrirTelaDaMensagem);

    // App FECHADO e foi iniciado pelo toque na notificação.
    final inicial = await fcm.getInitialMessage();
    if (inicial != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _abrirTelaDaMensagem(inicial);
      });
      SchedulerBinding.instance.ensureVisualUpdate();
    }
  }

  static void _aoReceberComAppAberto(RemoteMessage message) {
    final titulo = message.notification?.title ?? 'Novo aviso';
    final corpo = message.notification?.body ?? '';
    final temTela = buscarIncidentePorId(message.data['id']) != null;

    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          content: Text(corpo.isEmpty ? titulo : '$titulo\n$corpo'),
          action: temTela
              ? SnackBarAction(
                  label: 'Ver',
                  onPressed: () => _abrirTelaDaMensagem(message),
                )
              : null,
        ),
      );
  }

  /// Lê os dados da mensagem (`tela` e `id`) e abre o incidente correspondente.
  static void _abrirTelaDaMensagem(RemoteMessage message) {
    final tela = message.data['tela'];
    final incidente = buscarIncidentePorId(message.data['id']);
    debugPrint('[FCM] toque na notificação: tela=$tela id=${message.data['id']}');

    if (tela != 'incidente' || incidente == null) return;

    navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (_) => DetalheIncidenteScreen(incidente: incidente),
      ),
    );
  }
}
