# Samsung Home Server

Transforme um **Samsung Galaxy S9+ antigo** em um homeserver de baixo consumo, rodando Linux (via [Termux](https://github.com/termux/termux-app)) com SSH, tarefas agendadas e serviços que sobem sozinhos quando o celular liga.

Em vez de deixar o aparelho na gaveta, ele passa a hospedar seus próprios apps, arquivos e automações 24h por dia, gastando bem menos energia que um PC ou mini-servidor.

## O que você ganha

- **Acesso remoto por SSH/SFTP** (porta `8022`) a partir de qualquer computador da rede local.
- **Gerenciamento de serviços** com `runit` (`termux-services`): iniciar, parar, reiniciar e habilitar no boot.
- **Inicialização automática** após reiniciar o celular, via Termux:Boot.
- **Agendador de tarefas** (`cron`) para backups e rotinas.
- **Ambiente de desenvolvimento** pronto: Python, Node.js LTS, Git, tmux, rsync, htop.
- **Comandos utilitários**: `status` (serviços, disco e IP), `logs <serviço>` e `rx` (recebe arquivos pelo terminal).
- **Script para publicar qualquer app como serviço** (`add-service.sh`).
- **Painel para Windows**: atalhos de duplo clique para administrar o servidor do PC, sem digitar comandos.

## Requisitos

| Item | Detalhe |
|---|---|
| Aparelho | Samsung Galaxy S9+ (ou outro Android com Termux) |
| Termux | Versão do **GitHub** (a do F-Droid/Play Store não é compatível com os add-ons atuais). Em **Android 5/6** use a variante `apt-android-5`, veja [`docs/instalacao.md`](docs/instalacao.md) |
| Add-ons | **Termux:Boot** (também da versão GitHub, mesma origem do Termux) |
| Rede | Wi-Fi da casa, de preferência com **IP fixo reservado no roteador** |
| Energia | Carregador conectado; recomenda-se limitar a carga a ~80% para preservar a bateria |

## Instalação rápida

1. Instale o **Termux** e o **Termux:Boot** pelas releases do GitHub e abra o Termux-Boot uma vez.
2. No Termux, baixe e rode o script de setup:

   ```bash
   pkg install -y git
   git clone https://github.com/mechamocharles/Samsung-Home-Server.git
   cd Samsung-Home-Server
   bash scripts/setup-homeserver.sh
   ```

3. Feche e reabra o Termux para os serviços iniciarem.
4. Defina uma senha para acessar por SSH e descubra o IP do aparelho:

   ```bash
   passwd
   status
   ```

5. Do seu computador:

   ```bash
   ssh -p 8022 <IP-DO-CELULAR>
   ```

O passo a passo completo, incluindo as configurações do Android que evitam que o sistema mate o servidor, está em [`docs/instalacao.md`](docs/instalacao.md).

## O que o `setup-homeserver.sh` faz

1. Atualiza os pacotes do Termux.
2. Instala `python`, `nodejs-lts`, `git`, `termux-services`, `tmux`, `cronie`, `nano`, `htop`, `rsync` e `openssh`.
3. Cria as pastas `~/apps`, `~/files`, `~/logs`, `~/bin` e `~/.ssh`.
4. Cria o script de boot `~/.termux/boot/00-homeserver.sh`, que ativa o *wake-lock* e inicia os serviços.
5. Instala os comandos `status`, `rx`, `logs` e `add-service` em `~/bin`.
6. Habilita os serviços `sshd` e `crond`.

## Estrutura do repositório

```
Samsung-Home-Server/
├── README.md
├── scripts/
│   ├── setup-homeserver.sh   # instalação base do servidor
│   ├── add-service.sh        # cria um serviço runit para qualquer app
│   └── logs                  # acompanha o log de um serviço
├── windows/
│   ├── S9 Terminal.bat       # abre o terminal do celular via SSH
│   └── S9 Painel.bat         # menu com as tarefas do dia a dia
└── docs/
    ├── instalacao.md         # passo a passo detalhado
    ├── acesso-pelo-pc.md     # controlar o servidor pelo Windows
    ├── operacao.md           # uso diário: serviços, cron, backup, atualização
    └── solucao-de-problemas.md
```

## Controle pelo PC (Windows)

Com o servidor de pé, o celular pode ficar num canto, só no carregador. Os atalhos da pasta [`windows/`](windows) permitem administrá-lo com um duplo clique:

- **`S9 Terminal.bat`**: abre direto o terminal do celular.
- **`S9 Painel.bat`**: menu para ver status, acompanhar logs, reiniciar serviços, enviar arquivos, baixar backups e configurar o login sem senha.

Edite a linha `set S9=IP-DO-CELULAR` nos dois arquivos com o IP do seu aparelho e, na primeira vez, use a **opção 8** do painel (login sem senha). Detalhes em [`docs/acesso-pelo-pc.md`](docs/acesso-pelo-pc.md).

## Publicando seus próprios apps

Qualquer aplicação pode virar um serviço que sobe com o celular:

```bash
# Site estático na porta 8080
add-service meu-site \
  'exec python -m http.server 8080 --bind 0.0.0.0 --directory $HOME/apps/meu-site 2>&1'

sv-enable meu-site     # liga agora e habilita no boot
logs meu-site          # acompanha o log
```

Mais detalhes em [`docs/operacao.md`](docs/operacao.md).

## Comandos do dia a dia

| Comando | O que faz |
|---|---|
| `status` | Mostra serviços, espaço em disco e IP |
| `logs <serviço>` | Acompanha o log do serviço |
| `sv status <serviço>` | Estado de um serviço |
| `sv restart <serviço>` | Reinicia um serviço |
| `sv-enable <serviço>` / `sv-disable <serviço>` | Habilita / desabilita no boot |
| `crontab -e` | Edita as tarefas agendadas |

## Segurança

- O SSH usa **senha** por padrão. Para uso contínuo, prefira **chave SSH** e depois desative o login por senha.
- Não exponha a porta `8022` (nem outros serviços) diretamente na internet. Para acesso externo, use uma VPN (como WireGuard ou Tailscale).
- Nunca versione arquivos `.env`, tokens ou backups. O `.gitignore` já cobre os casos mais comuns.

## Licença

Defina a licença do projeto conforme sua preferência (por exemplo, MIT) adicionando um arquivo `LICENSE` na raiz.
