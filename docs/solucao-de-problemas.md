# Solução de problemas

## O servidor para de responder depois de um tempo

O Android encerra processos em segundo plano para economizar bateria.

- Confirme que o Termux e o Termux:Boot estão **sem otimização de bateria**.
- Verifique se o *wake-lock* está ativo: deve aparecer uma notificação fixa do Termux com a opção "Release wake lock".
- Confirme que o aparelho está carregando e que o Wi-Fi não está configurado para desligar em suspensão (*Wi-Fi → Avançado → Manter Wi-Fi ligado durante o repouso → Sempre*).

## Os serviços não sobem após reiniciar o celular

1. Confirme que o **Termux:Boot** foi aberto pelo menos uma vez.
2. Confirme que ele veio da mesma origem do Termux (GitHub).
3. Verifique o script de boot:

   ```bash
   cat ~/.termux/boot/00-homeserver.sh
   ```

   Ele deve conter `termux-wake-lock` e a linha que carrega `start-services.sh`.
4. Teste manualmente:

   ```bash
   sh ~/.termux/boot/00-homeserver.sh && status
   ```

## `ssh: connect to host ... port 8022: Connection refused` (ou timeout)

- O celular e o computador precisam estar na **mesma rede**.
- Descubra o IP atual com `status`. Se mudou, reserve um IP fixo no roteador.
- Verifique o `sshd`:

  ```bash
  sv status sshd
  sv restart sshd
  logs sshd
  ```

- Alguns roteadores ativam o **isolamento de clientes** (AP isolation) no Wi-Fi, o que bloqueia a comunicação entre dispositivos.

## `Permission denied` ao conectar por SSH

- Defina novamente a senha no celular com `passwd`.
- Se estiver usando chave, confira as permissões: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys`.

## `pkg` falha com erro de assinatura ou repositório

Costuma indicar mistura de versões do Termux (F-Droid e GitHub). Desinstale tudo e reinstale todos os componentes da mesma origem (GitHub). Se o espelho estiver lento ou indisponível, rode `termux-change-repo` e escolha outro.

## Serviço novo não inicia

```bash
sv status <serviço>      # mostra "down" se ainda não foi habilitado
sv-enable <serviço>
logs <serviço>           # veja o erro
```

Verifique se o comando de execução termina com `exec` e usa caminhos absolutos ou variáveis (`$HOME`, `$PREFIX`).

## Pouco espaço em disco

```bash
status                       # espaço livre
du -sh ~/* | sort -h         # maiores pastas
pkg clean                    # limpa o cache de pacotes
```

## Teclado físico (Samsung DeX)

Se estiver usando DeX com teclado físico e as teclas saírem trocadas, ajuste o layout em *Configurações → Gerenciamento geral → Teclado físico → Layout do teclado* (por exemplo, Português Brasileiro / ABNT2 ou "Brazilian Qwerty").
