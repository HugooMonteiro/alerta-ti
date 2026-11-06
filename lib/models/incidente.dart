import 'package:flutter/material.dart';

enum StatusIncidente {
  agendado('Agendado', Color(0xFF1565C0)),
  emInvestigacao('Em investigação', Color(0xFFF9A825)),
  emAndamento('Em andamento', Color(0xFFEF6C00)),
  alertaAtivo('Alerta ativo', Color(0xFFC62828)),
  resolvido('Resolvido', Color(0xFF2E7D32));

  final String rotulo;
  final Color cor;
  const StatusIncidente(this.rotulo, this.cor);
}

class Incidente {
  final String id;
  final String titulo;
  final StatusIncidente status;
  final String sistema;
  final String atualizadoEm;
  final String descricao;
  final String contorno;

  /// Caminho de uma imagem em assets/ (opcional).
  final String? imagemAsset;

  const Incidente({
    required this.id,
    required this.titulo,
    required this.status,
    required this.sistema,
    required this.atualizadoEm,
    required this.descricao,
    required this.contorno,
    this.imagemAsset,
  });
}

/// Dados FICTÍCIOS definidos no código (não há banco de dados nem login).
/// O campo `id` é o que a notificação envia em `data` para abrir a tela certa.
const List<Incidente> incidentes = [
  Incidente(
    id: '101',
    titulo: 'Manutenção programada: sistema de protocolo',
    status: StatusIncidente.agendado,
    sistema: 'Protocolo',
    atualizadoEm: 'Hoje, 09:00',
    descricao:
        'O sistema de protocolo ficará fora do ar hoje, das 14h às 16h, '
        'para atualização do servidor de aplicação e do banco de dados.',
    contorno:
        'Registre os documentos urgentes em papel e lance no sistema depois '
        'das 16h. Evite deixar cadastros pela metade perto das 14h.',
  ),
  Incidente(
    id: '102',
    titulo: 'VPN instável',
    status: StatusIncidente.emAndamento,
    sistema: 'VPN / acesso remoto',
    atualizadoEm: 'Hoje, 10:42',
    descricao:
        'Usuários relatam quedas frequentes de conexão na VPN. A equipe '
        'identificou sobrecarga no concentrador e está aplicando a correção.',
    contorno:
        'Desconecte e reconecte a VPN escolhendo o servidor secundário '
        '("VPN-02") na lista. Se continuar caindo, trabalhe com os arquivos '
        'salvos localmente e sincronize depois.',
  ),
  Incidente(
    id: '103',
    titulo: 'Alerta de phishing: e-mail falso pedindo senha',
    status: StatusIncidente.alertaAtivo,
    sistema: 'E-mail institucional',
    atualizadoEm: 'Hoje, 08:15',
    descricao:
        'Circula um e-mail falso, que simula o suporte de TI, pedindo para '
        'o usuário "confirmar a senha" em um link externo. O suporte nunca '
        'pede senha por e-mail.',
    contorno:
        'Não clique no link nem responda. Encaminhe a mensagem ao setor de '
        'TI como anexo e apague-a. Se já informou sua senha, troque-a '
        'imediatamente e avise o suporte.',
    imagemAsset: 'assets/phishing_exemplo.png',
  ),
  Incidente(
    id: '104',
    titulo: 'Impressoras do 2º andar sem comunicação',
    status: StatusIncidente.resolvido,
    sistema: 'Impressão',
    atualizadoEm: 'Ontem, 17:30',
    descricao:
        'As impressoras do 2º andar ficaram sem comunicação com o servidor '
        'de impressão por causa de uma troca de switch. O serviço foi '
        'normalizado.',
    contorno:
        'Nenhuma ação necessária. Se a impressora ainda não aparecer, '
        'reinicie o computador e tente novamente.',
  ),
];

Incidente? buscarIncidentePorId(String? id) {
  if (id == null) return null;
  for (final i in incidentes) {
    if (i.id == id) return i;
  }
  return null;
}
