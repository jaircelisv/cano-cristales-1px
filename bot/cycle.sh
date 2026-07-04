#!/usr/bin/env bash
# Caño Cristales 1px — hace fluir el pixel (295,487) por los 5 colores del río.
# Cada etapa = una recompra vía MPP (el precio se duplica: diseño consciente del costo).
# Uso: ./cycle.sh [etapa_inicial 0-4] [intervalo_segundos]
set -euo pipefail

TEMPO="$HOME/.tempo/bin/tempo"
X=295 Y=487
URL="https://jaircelisv.github.io/cano-cristales-1px/"
EMAIL="jair@godat.co"
START="${1:-0}"
INTERVAL="${2:-90}"

COLORS=("#C1121F" "#E9C46A" "#2A9D8F" "#219EBC" "#22223B")
# máx 80 caracteres por label (regla del API)
LABELS=(
  "🔴 1/5 Caño Cristales 🇨🇴 la planta que enciende el río"
  "🟡 2/5 Caño Cristales 🇨🇴 arenas doradas bajo el agua"
  "🟢 3/5 Caño Cristales 🇨🇴 musgos y algas de la sierra"
  "🔵 4/5 Caño Cristales 🇨🇴 agua tan pura que no lleva sedimentos"
  "🌈 5/5 Caño Cristales 🇨🇴 el río de los 5 colores fluye en este pixel"
)

for i in $(seq "$START" 4); do
  echo "── Etapa $((i+1))/5: ${COLORS[$i]}"
  QUOTE=$(curl -s -X POST https://www.frontpage.sh/api/million/quote \
    -H 'content-type: application/json' \
    -d "{\"pixels\":[{\"x\":$X,\"y\":$Y,\"rgb\":\"${COLORS[$i]}\"}],\"url\":\"$URL\",\"label\":\"${LABELS[$i]}\"}")
  QUOTE_ID=$(echo "$QUOTE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["quoteId"])')
  TOTAL=$(echo "$QUOTE" | python3 -c 'import json,sys;print(json.load(sys.stdin)["totalUsd"])')
  echo "   quote $QUOTE_ID → \$$TOTAL"
  "$TEMPO" request -t -X POST --max-spend 0.75 \
    --json "{\"quoteId\":\"$QUOTE_ID\",\"email\":\"$EMAIL\"}" \
    https://www.frontpage.sh/api/million/buy
  echo "   ✓ comprado. Verificando:"
  curl -s "https://www.frontpage.sh/api/million/pixel?x=$X&y=$Y" | python3 -c 'import json,sys;p=json.load(sys.stdin);print(f"   rgb={p[\"rgb\"]} timesBought={p[\"timesBought\"]} next=${p[\"nextPriceUsd\"]}")'
  [ "$i" -lt 4 ] && sleep "$INTERVAL"
done
echo "🌈 El río completó su ciclo."
