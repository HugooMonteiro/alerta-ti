# Alerta TI

App Flutter simples que usa **notificações push (Firebase Cloud Messaging)** para avisar usuários sobre manutenções, golpes e incidentes de TI.

Atividade Prática — Notificações Push (Programação para Dispositivos Móveis).

## Finalidade

Manter servidores e funcionários informados sobre indisponibilidades, alertas de segurança e incidentes dos sistemas de TI, para que saibam o que está acontecendo e o que fazer sem precisar abrir chamado. Todos os dados do app são fictícios.

## As três notificações

| Desafio | Título | Mensagem | Dados extras (custom data) |
|---|---|---|---|
| 1. Simples | Manutenção programada | O sistema de protocolo ficará fora do ar hoje, das 14h às 16h. | nenhum |
| 2. Com imagem | Alerta de phishing | Circula um e-mail falso pedindo sua senha. Veja como ele é e não clique. | campo "Imagem" com URL pública da captura |
| 3. Navegação | Incidente #102: VPN instável | Estamos atuando na falha. Toque para ver o status e a solução temporária. | `tela` = `incidente`, `id` = `102` |

No desafio 3 o app lê `message.data['tela']` e `message.data['id']`, procura o incidente correspondente e abre a tela de detalhes. Isso funciona nos três estados do app: aberto, em segundo plano e fechado (iniciado pelo toque).

## Como rodar

Pré-requisitos: Flutter SDK, Node.js, um projeto no Firebase (plano Spark, sem cartão) e um celular Android (ou emulador com **Google Play**).

1. Extraia o ZIP e entre na pasta `alerta_ti`.
2. Gere a pasta `android/` (o ZIP traz só o código):
   ```bash
   flutter create --platforms=android --org br.edu.cesupa --project-name alerta_ti .
   ```
   Se o `lib/main.dart` voltar a ser o exemplo do contador, copie-o de novo do ZIP.
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Conecte o app ao Firebase:
   ```bash
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Escolha seu projeto e marque **Android**. Isso substitui `lib/firebase_options.dart` e coloca o `google-services.json` no lugar certo.
5. Em `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>` (antes de `<application>`), adicione:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```
6. Rode no aparelho:
   ```bash
   flutter run
   ```
   Aceite a permissão de notificações quando o Android pedir.

Se o build reclamar de `minSdkVersion`, defina `minSdk = 23` em `android/app/build.gradle(.kts)`.

## Como testar (Firebase Console)

1. Abra o app e toque em **Copiar token** na tela inicial.
2. No Firebase Console: **Messaging** (ou Engajamento > Messaging) > **Nova campanha** > **Notificações**.
3. Preencha título e texto. Para o desafio 2, preencha também **Imagem da notificação** com um link HTTPS público. Para o desafio 3, abra **Opções adicionais > Dados personalizados** e adicione `tela` = `incidente` e `id` = `102`.
4. Clique em **Enviar mensagem de teste**, cole o token e envie.

**Imagem pública:** envie o repositório ao GitHub e use o link "raw" de `assets/phishing_exemplo.png`, por exemplo
`https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/assets/phishing_exemplo.png`

### O que verificar

- **Desafio 1:** minimize o app (botão Home) e envie. A notificação deve aparecer na barra do Android.
- **Desafio 2:** com o app em segundo plano, a notificação deve mostrar a imagem (expanda-a na barra).
- **Desafio 3 (segundo plano):** envie com `tela` e `id`, toque na notificação e confira que a tela do incidente abre.
- **Desafio 3 (app fechado):** feche o app deslizando-o, envie, toque na notificação e confira que ele abre direto no incidente.
- **App aberto:** aparece um aviso interno na parte de baixo com o botão **Ver**.

## Estrutura

```
lib/
  main.dart                          inicialização do Firebase e do app
  firebase_options.dart              placeholder (gerado pelo flutterfire configure)
  models/incidente.dart              dados fictícios dos incidentes
  services/notificacao_service.dart  permissão, token, tratamento das mensagens, navegação
  screens/home_screen.dart           lista de avisos + token para testes
  screens/detalhe_incidente_screen.dart  detalhes do incidente
assets/phishing_exemplo.png          exemplo fictício de e-mail de phishing
```
