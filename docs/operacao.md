# Operação do dia a dia

## Serviços (runit)

O servidor usa `termux-services`, baseado em `runit`.

| Ação | Comando |
|---|---|
| Ver estado de todos | `status` |
| Ver estado de um | `sv status <serviço>` |
| Iniciar | `sv up <serviço>` |
| Parar | `sv down <serviço>` |
| Reiniciar | `sv restart <serviço>` |
| Habilitar (liga agora e no boot) | `sv-enable <serviço>` |
| Desabilitar | `sv-disable <serviço>` |
| Acompanhar log | `logs <serviço>` |

Os serviços ficam em `$PREFIX/var/service/` e os logs em `$PREFIX/var/log/sv/<serviço>/current`.

### Criar um serviço novo

```bash
add-service <nome> '<comando>'
sv-enable <nome>
```

O comando deve terminar com `exec`, para o `runit` supervisionar o processo corretamente, e redirecionar o erro para a saída padrão (`2>&1`) para que apareça no log.

Exemplo, uma API Node.js:

```bash
add-service minha-api 'cd $HOME/apps/minha-api
exec node server.js 2>&1'
sv-enable minha-api
```

Por padrão o serviço nasce **desligado**, o que permite configurar o app antes de iniciá-lo.

## Estrutura de pastas

| Pasta | Uso |
|---|---|
| `~/apps` | Código dos seus aplicativos |
| `~/files` | Arquivos, dados e backups |
| `~/logs` | Logs de scripts de instalação e manutenção |
| `~/bin` | Comandos próprios (`status`, `rx`, `logs`, `add-service`) |

## Tarefas agendadas (cron)

O `crond` já sobe como serviço. Para editar:

```bash
crontab -e
```

Exemplo de backup diário de uma pasta às 03:00, mantendo 30 dias:

```cron
0 3 * * * tar czf $HOME/files/backups/dados_$(date +\%F).tar.gz -C $HOME apps/meu-app/dados && find $HOME/files/backups -name "*.tar.gz" -mtime +30 -delete
```

> No `crontab`, o caractere `%` precisa ser escapado como `\%`.

## Transferir arquivos

### SFTP / SCP do computador

```bash
scp -P 8022 arquivo.zip <IP-DO-CELULAR>:~/files/
rsync -avz -e "ssh -p 8022" ./pasta/ <IP-DO-CELULAR>:~/apps/minha-pasta/
```

> O `scp` usa `-P` (maiúsculo) para a porta; o `ssh` usa `-p` (minúsculo).

### Comando `rx`

Recebe um arquivo codificado em *hex + gzip* pela entrada padrão, útil quando só há acesso a um terminal e não há como copiar arquivos. No computador:

```bash
python -c "import gzip,binascii,sys; print(binascii.hexlify(gzip.compress(open(sys.argv[1],'rb').read())).decode())" arquivo
```

No celular, cole a saída no comando:

```bash
rx destino.ext
```

## Atualizar o sistema

```bash
pkg update && pkg upgrade
```

Depois de grandes atualizações, reinicie os serviços (`sv restart <serviço>`) ou o Termux.

## Atualizar este projeto

```bash
cd ~/Samsung-Home-Server
git pull
```
