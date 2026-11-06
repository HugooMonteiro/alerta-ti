import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/incidente.dart';
import '../services/notificacao_service.dart';
import 'detalhe_incidente_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta TI'),
        backgroundColor: tema.colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _CartaoToken(),
          const SizedBox(height: 20),
          Text('Avisos e incidentes', style: tema.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final incidente in incidentes) _CartaoIncidente(incidente),
        ],
      ),
    );
  }
}

class _CartaoIncidente extends StatelessWidget {
  final Incidente incidente;

  const _CartaoIncidente(this.incidente);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, color: incidente.status.cor, size: 14),
        title: Text(incidente.titulo),
        subtitle: Text(
          '${incidente.status.rotulo} • ${incidente.atualizadoEm}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetalheIncidenteScreen(incidente: incidente),
          ),
        ),
      ),
    );
  }
}

/// Mostra o token FCM do aparelho: é ele que se cola no Firebase Console
/// em "Enviar mensagem de teste".
class _CartaoToken extends StatelessWidget {
  const _CartaoToken();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      color: tema.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<String?>(
          valueListenable: NotificacaoService.token,
          builder: (context, token, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined),
                    const SizedBox(width: 8),
                    Text(
                      'Token deste aparelho (para testes)',
                      style: tema.textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (token == null)
                  const Text('Obtendo token…')
                else ...[
                  Text(
                    token,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copiar token'),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: token));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Token copiado')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
