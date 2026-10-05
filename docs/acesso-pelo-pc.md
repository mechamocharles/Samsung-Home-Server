# Controle pelo PC (Windows)

Depois que o servidor está de pé, você não precisa de cabo, DeX nem de mexer no celular. O aparelho pode ficar num canto, só no carregador, e você o administra de qualquer computador da rede.

## Como funciona

A janela do PowerShell (ou do atalho) é apenas um **controle remoto**. Quando você roda `ssh`, tudo o que digita ali é executado **no S9+**, não no PC. A mesma conexão é usada para enviar e receber arquivos (`scp`/`rsync`), então um único canal faz tudo.

## Atalhos prontos

A pasta [`windows/`](../windows) tem dois atalhos que funcionam com um duplo clique. O Windows 10/11 já traz o cliente OpenSSH (`ssh` e `scp`).

| Arquivo | O que faz |
|---|---|
| `S9 Terminal.bat` | Abre direto o terminal do celular |
| `S9 Painel.bat` | Menu com as tarefas do dia a dia |

### Antes de usar: informe o IP

Abra cada `.bat` (botão direito → **Editar**) e troque o valor na linha:

```bat
set S9=IP-DO-CELULAR
```

pelo IP do celular (aparece no comando `status`). Reservar o IP no roteador evita ter que repetir isso.

### Menu do `S9 Painel.bat`

```
 1. Abrir terminal do celular
 2. Ver status dos servicos
 3. Ver logs de um servico (Ctrl+C para sair)
 4. Reiniciar um servico
 5. Abrir no navegador um servico web (porta)
 6. Enviar arquivo para o servidor (~/files)
 7. Baixar arquivos de ~/files/backups para o PC
 8. Configurar login sem senha (uma vez so)
 0. Sair
```

**Use a opção 8 primeiro.** Ela cria uma chave de acesso no PC e a instala no celular. Pede a senha uma última vez; depois disso, nenhuma opção pede senha de novo.

Se quiser os atalhos na área de trabalho: botão direito no `.bat` → **Mostrar mais opções** → **Enviar para** → **Área de trabalho (criar atalho)**.

## Quando usar cada opção

- **Ver se está tudo rodando:** opção 2 (`status`).
- **Um serviço parou de responder:** opção 3 para ver o erro e opção 4 para reiniciar.
- **Mudou uma configuração (por exemplo, um `.env`):** abra o terminal (opção 1), edite com `nano` e reinicie o serviço (opção 4).
- **Guardar arquivos no servidor:** opção 6. Também dá para arrastar e soltar pelo WinSCP, usando SFTP na porta 8022.
- **Antes de mexer em algo importante:** gere seu backup e use a opção 7 para copiá-lo para o PC.

## Comandos mais usados dentro do terminal

| Comando | Para quê |
|---|---|
| `status` | Serviços, disco e IP |
| `logs <serviço>` | Acompanhar o log |
| `sv restart <serviço>` | Reiniciar um serviço |
| `exit` | Fecha a conexão. **Não** desliga nada no celular |

## Se o IP do celular mudar

Troque o número na linha `set S9=...` dos dois arquivos (botão direito → **Editar**). Com o IP reservado no roteador isso não acontece.

## Acesso manual, sem os atalhos

```powershell
ssh -p 8022 <IP-DO-CELULAR>
scp -P 8022 arquivo.zip <IP-DO-CELULAR>:~/files/
```

Lembre: no `ssh` a porta é `-p` (minúsculo); no `scp` é `-P` (maiúsculo).
