# 🔔 Alerta TI

App mobile em **Flutter** que usa **notificações push (Firebase Cloud Messaging)** para avisar usuários sobre manutenções, golpes e incidentes de TI.

> Atividade Prática — Notificações Push · Programação para Dispositivos Móveis · CESUPA
> Autor: Hugo de Oliveira Monteiro · Engenharia da Computação

---

## 📌 Finalidade

Em uma instituição, quem depende dos sistemas de TI precisa saber rápido quando algo para de funcionar, quando há um golpe circulando e o que fazer a respeito, sem abrir chamado. O **Alerta TI** entrega esses avisos direto no celular, mesmo com o app fechado.

- **Público-alvo:** servidores e funcionários que usam os sistemas internos de uma instituição.
- **Dados:** todos os incidentes do app são **fictícios**, definidos no código. Não há login, banco de dados nem backend.

## ✅ Os três desafios

| # | Desafio | Exemplo enviado | O que o app faz |
|---|---|---|---|
| 1 | **Notificação simples** | *Manutenção programada* — "O sistema de protocolo ficará fora do ar hoje, das 14h às 16h." | Android exibe a notificação com o app em segundo plano |
| 2 | **Notificação com imagem** | *Alerta de phishing* — "Circula um e-mail falso pedindo sua senha. Veja como ele é e não clique." + imagem do e-mail falso | A imagem aparece na notificação expandida |
| 3 | **Notificação com navegação** | *Incidente #102: VPN instável* + dados `tela=incidente`, `id=102` | Ao tocar, abre direto a tela do incidente, com o app em segundo plano **ou fechado** |

**Por que esses três tipos:** o aviso simples informa rápido; a imagem permite que o usuário *reconheça* o golpe visualmente; e a navegação leva ao detalhe (status e instrução de contorno), que não cabe dentro de uma notificação.

## 📱 Telas

- **Início:** token FCM do aparelho (com botão para copiar, usado nos testes) e a lista de avisos e incidentes, com uma bolinha colorida por status.
- **Detalhes do incidente:** status, sistema afetado, o que está acontecendo, **instrução de contorno** e, no caso do phishing, a imagem do e-mail falso.

| Status | Cor |
|---|---|
| Agendado | 🔵 azul |
| Em andamento | 🟠 laranja |
| Alerta ativo | 🔴 vermelho |
| Resolvido | 🟢 verde |

Incidentes de exemplo: `101` manutenção do protocolo · `102` VPN instável · `103` phishing · `104` impressoras do 2º andar.

## ⚙️ Como funciona

1. Ao abrir, o app inicializa o Firebase, **pede a permissão** de notificações (Android 13+) e obtém o **token FCM**.
2. O envio é manual, pelo **Firebase Console**; não há servidor próprio.
3. O app trata a mensagem conforme o estado em que está:

| Estado do app | Quem mostra a notificação | Ao tocar |
|---|---|---|
| **Aberto** | O próprio app (aviso interno com botão **Ver**) | Botão **Ver** abre o incidente |
| **Segundo plano** | O sistema Android | `onMessageOpenedApp` lê os dados e abre a tela |
| **Fechado** | O sistema Android | `getInitialMessage` lê os dados e abre a tela na inicialização |

4. Para navegar, a mensagem carrega **dados personalizados**: `tela` (qual tela abrir) e `id` (qual incidente). O app procura o incidente pelo `id` e abre a tela de detalhes. Se o `id` não existir, apenas abre a tela inicial.

## 🧰 Tecnologias

| Pacote | Uso |
|---|---|
| Flutter / Dart | Interface e lógica |
| `firebase_core` | Inicialização do Firebase |
| `firebase_messaging` | Recebimento das notificações (FCM) |

Plano gratuito **Spark** do Firebase, sem cartão de crédito. Plataforma testada: **Android**.

## 🚀 Como rodar

**Pré-requisitos:** [Flutter SDK](https://docs.flutter.dev/get-started/install), Android Studio (com SDK e emulador), Git, Node.js e um projeto no [Firebase](https://console.firebase.google.com). Use um emulador **com Google Play** (API 33+) ou um celular Android; sem o Google Play o FCM não funciona.

```bash
git clone https://github.com/HugooMonteiro/alerta-ti.git
cd alerta-ti
flutter pub get
```

Este repositório já traz a pasta `android/` com a permissão `POST_NOTIFICATIONS` e `minSdk 23` configurados. Falta ligar o app **ao seu projeto Firebase** (o `firebase_options.dart` do repositório pertence ao projeto do autor):

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --platforms=android
```

> **Windows:** se aparecer *"flutterfire não é reconhecido"*, use
> `dart pub global run flutterfire_cli:flutterfire configure --platforms=android`
> ou adicione `%LOCALAPPDATA%\Pub\Cache\bin` ao PATH.

Depois rode o app e **aceite a permissão** de notificações:

```bash
flutter run
```

## 🧪 Como testar

No Firebase Console, abra **Messaging** > **Nova campanha** > **Mensagens de notificação do Firebase**. Antes de enviar, toque em **Copiar token** na tela inicial do app.

**Desafio 1 — simples**
1. Minimize o app (botão Home).
2. Preencha título e texto e clique em **Enviar mensagem de teste**, colando o token.
3. ✔ A notificação aparece na barra do Android.

**Desafio 2 — imagem**
1. Preencha também **Imagem da notificação** com um link HTTPS **público**. Uma opção é o link raw deste repositório (que precisa ser público):
   `https://raw.githubusercontent.com/HugooMonteiro/alerta-ti/main/assets/phishing_exemplo.png`
2. Com o app minimizado, envie e **expanda** a notificação.
3. ✔ A imagem do e-mail falso aparece.

**Desafio 3 — navegação**
1. Crie uma campanha com **Destino = Aplicativo** (`alerta_ti`).
2. Em **Opções adicionais > Dados personalizados**, adicione `tela` = `incidente` e `id` = `102`.
3. Em **Agendamento**, deixe "Agora" e publique.
4. Teste com o app **em segundo plano** e com o app **fechado** (deslize-o nos recentes).
5. ✔ Ao tocar na notificação, abre a tela **Incidente #102 — VPN instável**.

### Observações

- **Banner na tela:** as notificações do Console usam o canal padrão do Android (*Miscellaneous*), que faz som e mostra o ícone, mas não abre banner. Para ver o banner, ative **Exibir na tela** nas configurações de notificação do app.
- **Mensagem de teste × campanha:** a mensagem de teste pode não levar os dados personalizados. Para o desafio 3, use campanha (dá para **duplicar** uma campanha pronta).
- **Não use "Forçar parada":** o Android bloqueia notificações para apps forçados a parar.
- O token muda se o app for desinstalado ou os dados forem apagados.

## 🗂️ Estrutura

```
lib/
├── main.dart                              # inicialização do Firebase e do app
├── firebase_options.dart                  # gerado pelo flutterfire configure
├── models/
│   └── incidente.dart                     # modelo e dados fictícios dos incidentes
├── services/
│   └── notificacao_service.dart           # permissão, token, tratamento das mensagens, navegação
└── screens/
    ├── home_screen.dart                   # lista de avisos + token para testes
    └── detalhe_incidente_screen.dart      # detalhes do incidente
assets/
└── phishing_exemplo.png                   # exemplo fictício de e-mail de phishing
```

## 📝 Limitações

- Dados fictícios fixos no código; as notificações não atualizam a lista.
- Sem backend: o envio é manual, pelo Firebase Console.
- Testado apenas em Android.