import 'package:flutter/material.dart';

import '../models/incidente.dart';

class DetalheIncidenteScreen extends StatelessWidget {
  final Incidente incidente;

  const DetalheIncidenteScreen({super.key, required this.incidente});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Incidente #${incidente.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(
                label: Text(
                  incidente.status.rotulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: incidente.status.cor,
                side: BorderSide.none,
              ),
              Text(
                'Atualizado: ${incidente.atualizadoEm}',
                style: tema.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(incidente.titulo, style: tema.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Sistema afetado: ${incidente.sistema}',
            style: tema.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _Bloco(
            icone: Icons.info_outline,
            titulo: 'O que está acontecendo',
            texto: incidente.descricao,
          ),
          const SizedBox(height: 12),
          _Bloco(
            icone: Icons.alt_route,
            titulo: 'Instrução de contorno',
            texto: incidente.contorno,
            destaque: true,
          ),
          if (incidente.imagemAsset != null) ...[
            const SizedBox(height: 20),
            Text('Exemplo do e-mail falso', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(incidente.imagemAsset!),
            ),
          ],
        ],
      ),
    );
  }
}

class _Bloco extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String texto;
  final bool destaque;

  const _Bloco({
    required this.icone,
    required this.titulo,
    required this.texto,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      color: destaque ? tema.colorScheme.secondaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, size: 20),
                const SizedBox(width: 8),
                Text(titulo, style: tema.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(texto, style: tema.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
