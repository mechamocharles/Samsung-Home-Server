#!/data/data/com.termux/files/usr/bin/bash
# Setup base do homeserver S9+ (Termux)
set -e
echo "== Atualizando pacotes =="
yes | pkg update
yes | pkg upgrade -o Dpkg::Options::="--force-confold"
echo "== Instalando ferramentas =="
pkg install -y python nodejs-lts git termux-services tmux cronie nano htop rsync openssh

echo "== Pastas =="
mkdir -p ~/apps ~/files ~/logs ~/bin ~/.termux/boot ~/.ssh
chmod 700 ~/.ssh

echo "== Script de boot (Termux:Boot) =="
cat > ~/.termux/boot/00-homeserver.sh <<'BOOT'
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
. $PREFIX/etc/profile.d/start-services.sh
BOOT
chmod +x ~/.termux/boot/00-homeserver.sh

echo "== Comando 'status' =="
cat > ~/bin/status <<'ST'
#!/data/data/com.termux/files/usr/bin/bash
echo "== Servicos =="; for s in $PREFIX/var/service/*; do printf '%-20s ' "$(basename $s)"; sv status "$(basename $s)" 2>/dev/null | cut -d: -f1-2; done
echo "== Disco =="; df -h ~ | tail -1
echo "== IP =="; ip -4 addr show wlan0 2>/dev/null | grep inet || ifconfig 2>/dev/null | grep 'inet 192'
ST
chmod +x ~/bin/status
grep -q 'HOME/bin' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc

echo "== Comando 'rx' (recebe arquivo em hex+gzip) =="
cat > ~/bin/rx <<'RX'
#!/data/data/com.termux/files/usr/bin/python
import sys,zlib,binascii
d=zlib.decompress(binascii.unhexlify(input().strip()),31)
open(sys.argv[1],'wb').write(d); print('ok',sys.argv[1],len(d),'bytes')
RX
chmod +x ~/bin/rx

echo "== Comandos 'logs' e 'add-service' (se rodando a partir do repositorio) =="
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/logs" ]; then
  install -m 755 "$SCRIPT_DIR/logs" ~/bin/logs
fi
if [ -f "$SCRIPT_DIR/add-service.sh" ]; then
  install -m 755 "$SCRIPT_DIR/add-service.sh" ~/bin/add-service
fi

echo "== Ativando sshd e crond como servicos =="
. $PREFIX/etc/profile.d/start-services.sh 2>/dev/null || true
sleep 2
sv-enable sshd || true
sv-enable crond || true

termux-wake-lock || true
echo
echo "PRONTO. Feche e reabra o Termux para os servicos iniciarem."
