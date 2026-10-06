# Instalação passo a passo

Este guia leva um Galaxy S9+ do zero até um homeserver acessível por SSH.

## 1. Instalar o Termux (versão GitHub)

Baixe o APK do **Termux** e do **Termux:Boot** nas páginas de releases do GitHub:

- Termux: <https://github.com/termux/termux-app/releases>
- Termux:Boot: <https://github.com/termux/termux-boot/releases>

> **Importante:** todos os componentes do Termux precisam vir da **mesma origem** (GitHub). Misturar a versão do F-Droid ou da Play Store com add-ons do GitHub (ou vice-versa) causa falhas de assinatura e de instalação de pacotes.

> **Android 5 ou 6** (ex.: Galaxy Note 4, S5): o Termux estável exige Android 7+. Use o APK
> `termux-app_v0.119.0-beta.*+apt-android-5-github-debug_armeabi-v7a.apk` da página de releases.
> O repositório de pacotes dessa variante é congelado (Python 3.8, Node.js 12, OpenSSH 8.1) e não
> tem `cronie`; o `setup-homeserver.sh` detecta isso e usa o `crond` do busybox.

Depois de instalar, **abra o Termux:Boot uma vez**. Sem isso o Android não permite que ele execute no boot.

## 2. Ajustes no Android

Para o servidor não ser encerrado pelo sistema:

1. **Bateria sem otimização** para o Termux e o Termux:Boot: *Configurações → Apps → Termux → Bateria → Sem restrições*.
2. Remova o Termux da lista de apps em suspensão: *Configurações → Cuidados com o dispositivo → Bateria → Limites de uso em segundo plano*.
3. Mantenha o aparelho no carregador. Se possível, ative a proteção de bateria (limite de carga em ~80%).
4. Conceda acesso ao armazenamento, se quiser trocar arquivos com o Android:

   ```bash
   termux-setup-storage
   ```

## 3. Rodar o setup

```bash
pkg install -y git
git clone https://github.com/mechamocharles/Samsung-Home-Server.git
cd Samsung-Home-Server
bash scripts/setup-homeserver.sh
```

Ao final, feche e reabra o Termux.

## 4. Acesso por SSH

No celular:

```bash
passwd      # define a senha de acesso SSH
status      # mostra o IP na rede
whoami      # usuário do Termux (ex.: u0_a123)
```

No computador:

```bash
ssh -p 8022 <IP-DO-CELULAR>
```

O SSH do Termux usa a **porta 8022**. O Termux aceita qualquer nome de usuário na conexão, então `ssh -p 8022 <IP-DO-CELULAR>` funciona com a senha definida no `passwd`.

### Reservar IP fixo

Para o endereço não mudar, reserve o IP do celular no roteador (reserva de DHCP pelo endereço MAC).

### Login por chave (recomendado)

No computador:

```bash
ssh-keygen -t ed25519
ssh-copy-id -p 8022 <IP-DO-CELULAR>   # no Windows, copie a chave pública manualmente para ~/.ssh/authorized_keys
```

No Windows, o atalho `windows/S9 Painel.bat` (opção 8) faz isso por você, veja [`acesso-pelo-pc.md`](acesso-pelo-pc.md). Manualmente, sem `ssh-copy-id`, pelo PowerShell:

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh -p 8022 <IP-DO-CELULAR> "cat >> ~/.ssh/authorized_keys"
```

## 5. Validar o boot automático

1. Reinicie o celular.
2. Aguarde alguns minutos, sem abrir o Termux.
3. Tente conectar por SSH do computador. Se conectar, o Termux:Boot e o `sshd` estão funcionando.

## 6. Resultado esperado

O comando `status` deve listar os serviços `sshd` e `crond` ativos (`run`), mostrar o espaço livre em disco e o IP da rede.
