#!/data/data/com.termux/files/usr/bin/bash
# Cria um serviço runit (termux-services) para qualquer aplicação.
#
# Uso:
#   add-service.sh <nome> '<comando>'
#
# Exemplos:
#   add-service.sh meu-site 'exec python -m http.server 8080 --bind 0.0.0.0 --directory $HOME/apps/meu-site 2>&1'
#   add-service.sh minha-api 'cd $HOME/apps/minha-api
#   exec node server.js 2>&1'
#
# O serviço é criado DESLIGADO (arquivo "down"). Para ligar e habilitar no boot:
#   sv-enable <nome>
set -e

if [ $# -ne 2 ]; then
  echo "Uso: $0 <nome> '<comando>'" >&2
  exit 1
fi

NAME="$1"
CMD="$2"
SV="$PREFIX/var/service"
LOGDIR="$PREFIX/var/log/sv/$NAME"

[ -n "$SVDIR" ] || . "$PREFIX/etc/profile.d/start-services.sh"

mkdir -p "$SV/$NAME/log" "$LOGDIR"
touch "$SV/$NAME/down"

printf '#!/data/data/com.termux/files/usr/bin/sh\n%s\n' "$CMD" > "$SV/$NAME/run"
printf '#!/data/data/com.termux/files/usr/bin/sh\nexec svlogd -tt %s\n' "$LOGDIR" > "$SV/$NAME/log/run"
chmod +x "$SV/$NAME/run" "$SV/$NAME/log/run"

echo "Serviço '$NAME' criado (desligado)."
echo "  Ligar e habilitar no boot : sv-enable $NAME"
echo "  Ver logs                  : logs $NAME"
