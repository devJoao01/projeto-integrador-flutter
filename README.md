# 🔥 Configurando o Firebase no seu Projeto Flutter

DOCUMENTAÇÃO: [Firebase Passo a Passo](https://firebase.google.com/docs/flutter/setup?hl=pt-br&platform=android).
## 🚀 Passo a Passo

### 1. Criar um Projeto no Firebase Console
1. Acesse o [Firebase Console](https://console.firebase.google.com/).
2. Clique em **Adicionar Projeto**.
3. Escolha um nome para o projeto e siga as etapas para criá-lo.
4. No painel do projeto, adicione um app Android.

### 2. Baixar o arquivo `google-services.json`
1. Após adicionar o app Android no Firebase Console, será gerado um arquivo `google-services.json`.
2. Faça o download desse arquivo.

### 3. Mover o arquivo `google-services.json` para o projeto Flutter
1. Coloque o arquivo baixado na pasta `android/app` do seu projeto Flutter.
   
   **Estrutura do projeto:**
   ```plaintext
   android/
     app/
       google-services.json

### 4. Rodar o comando de login do Firebase
1. Abra o terminal na raiz do seu projeto Flutter.
2. Execute o seguinte comando para fazer login na sua conta do Firebase:
   ```bash
   firebase login

1. **Instalar o FlutterFire CLI:**
   - Para instalar a ferramenta FlutterFire CLI, abra o terminal na raiz do seu projeto Flutter e execute o seguinte comando:
   ```bash
   dart pub global activate flutterfire_cli

### 6. Configurar o Firebase no seu projeto Flutter
1. **Iniciar a configuração do Firebase:**
   - No terminal, ainda na raiz do seu projeto Flutter, execute o seguinte comando:
   ```bash
   flutterfire configure

   # Iniciar Assistente de Configuração do Firebase

### Selecionar o Projeto

Quando solicitado, você verá uma lista de projetos disponíveis vinculados à sua conta do Firebase. Selecione o projeto que você criou anteriormente no Firebase Console.

### Inserir o Namespace

Durante o processo de configuração, será solicitado que você insira o namespace do seu aplicativo. Para encontrá-lo:

1. Navegue até o arquivo `build.gradle` que está localizado em `android/app/build.gradle`.
2. Procure a linha que começa com `applicationId`. Por exemplo:

   ```groovy
   applicationId "com.seu_pacote.aqui"
   


