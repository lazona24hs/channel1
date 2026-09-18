#!/bin/bash

# Define las URLs de los canales
declare -A CHANNELS=(
  ["CiudadMagazine"]="http://181.209.105.115:2525/play/ciudadmagazine"
  ["Canal2"]="http://181.209.105.115:2525/play/elnueve"
  ["Canal3"]="http://181.209.105.115:2525/play/metro"
  ["Cronica"]="http://181.209.105.115:2525/play/evento"
)

CHANNEL_ID="$1"
RTMP_SERVER="$2"
STREAM_KEY="$3"

STREAM_URL="${CHANNELS[$CHANNEL_ID]}"

if [ -z "$STREAM_URL" ]; then
  echo "Error: Canal '$CHANNEL_ID' no encontrado."
  exit 1
fi

echo "Iniciando $CHANNEL_ID..."
while true; do
  ffmpeg -rw_timeout 15000000 \
    -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "$STREAM_URL" \
    -c:v copy -c:a copy \
    -bsf:a aac_adtstoasc \
    -f flv "$RTMP_SERVER/$STREAM_KEY"

  echo "Conexión perdida en $CHANNEL_ID. Reintentando en 5s..."
  sleep 5
done
