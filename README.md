# Movimenta — Acompanhamento de Atividade Física para Idosos

Aplicativo de extensão universitária para apoiar idosos (ou seus cuidadores) no
acompanhamento de atividades físicas e alimentação. Diferente de relógios
inteligentes, o foco é **orientação e planejamento**: o usuário registra o que fez,
o app devolve **sugestões personalizadas** baseadas em metas de saúde para idosos
(OMS) e gera um **plano semanal** e um **acompanhamento de evolução**.

## Funcionalidades

- **Registrar**: atividades físicas (tipo, intensidade, duração, como se sentiu) e alimentação (categoria, descrição, ml de água).
- **Início**: progresso da semana (meta de 150 min) e sugestões automáticas.
- **Plano**: cronograma semanal de atividades.
- **Evolução**: gráfico de minutos por semana e sequência de dias ativos.
- **Acessível**: fontes grandes, alto contraste, poucos botões (pensado para idosos).
- **Offline**: todos os dados ficam salvos no próprio aparelho.

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão estável 3.x)
- [Git](https://git-scm.com/downloads)
- Editor: VS Code (extensão **Flutter**) ou Android Studio
- Para versão **mobile (Android)**: Android SDK (via Android Studio ou command-line tools) e um celular/emulador

## 1. Obter o código

Se o projeto estiver em um repositório Git:

```bash
git clone <URL_DO_REPOSITORIO>
cd projetoExtens-03
```

Ou baixe o ZIP deste projeto e extraia a pasta `projetoExtens-03`.

## 2. Instalar dependências

Dentro da pasta do projeto:

```bash
flutter pub get
```

## 3. Habilitar a plataforma web (só se necessário)

Se você baixou/clonou o projeto e ele não tiver a pasta `web/`, rode uma vez:

```bash
flutter create --platforms=web .
```

> Isso gera os arquivos da web sem apagar o seu código.

## 4. Rodar no navegador (Web)

Verifique os navegadores disponíveis:

```bash
flutter devices
```

Rode no Edge ou Chrome (o modo `--release` é mais leve/rápido):

```bash
flutter run -d edge --release
# ou
flutter run -d chrome --release
```

O app abre no navegador. Os dados ficam salvos no próprio navegador (localStorage).

## 5. Rodar no celular (Mobile / Android)

### Opção A — rodar direto no aparelho (modo desenvolvedor)

1. Ative a **Depuração USB** no celular (Configurações → Sobre o telefone → toque 7x em "Número da versão" → voltar → Opções do desenvolvedor → Depuração USB).
2. Conecte o cabo USB ao PC.
3. Confirme a permissão no celular.
4. Rode:

```bash
flutter run
```

### Opção B — emulador

No VS Code: `Ctrl+Shift+P` → **Flutter: Launch Emulator** (crie um se não houver). Depois `flutter run`.

### Gerar o APK instalável (versão final, sem programas auxiliares)

```bash
flutter build apk
```

O arquivo fica em:

```
build/app/outputs/flutter-apk/app-release.apk
```

Transfira o APK para o celular e instale (não precisa de loja nem do Expo Go).

> Na primeira vez no mobile, pode ser necessário aceitar as licenças do Android:
> ```bash
> flutter doctor --android-licenses
> ```

## Persistência de dados

O app usa `shared_preferences`: os registros ficam **no próprio dispositivo**
(navegador ou celular), funcionando offline e sem servidor. Não há envio de dados
para a nuvem. Para apagar, basta limpar os dados do app/navegador.

## Estrutura do projeto

```
lib/
├── main.dart                      # inicialização + tema
├── theme/app_theme.dart          # tema acessível (fontes grandes)
├── models/
│   ├── atividade.dart            # modelo de atividade física
│   └── alimentacao.dart          # modelo de alimentação
├── database/database_helper.dart # persistência local (shared_preferences)
├── services/
│   ├── sugestao_service.dart     # motor de sugestões (regras de saúde)
│   └── planejamento_service.dart # gera o plano semanal
└── screens/
    ├── home_page.dart            # navegação (4 abas)
    ├── inicio_screen.dart        # progresso + sugestões
    ├── registro_screen.dart      # cadastro de atividade/alimentação
    ├── plano_screen.dart         # cronograma semanal
    └── evolucao_screen.dart      # gráfico + sequência de dias
```

## Próximos passos (melhorias planejadas)

- Plano semanal **personalizado** a partir do histórico do usuário.
- Auto-atualização das telas Início/Evolução ao registrar algo.
- Tela de **histórico** com opção de excluir registros.
- **Modo cuidador** para acompanhamento remoto.
- Uso do campo "como se sentiu" nas sugestões.

## Comandos úteis

```bash
flutter pub get        # instalar pacotes
flutter clean          # limpar cache de build
flutter doctor         # verificar configuração do ambiente
flutter build apk      # gerar APK final
```
