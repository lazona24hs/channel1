#!/bin/bash

# Acepta cualquier tipo de flujo: M3U8, RTSP, RTMP, HTTP, etc.
STREAM_URL="http://181.209.105.115:2525/play/ciudadmagazine"

echo "Iniciando retransmisión desde: $STREAM_URL..."

while true; do
  # Evaluamos si la URL termina en .m3u8 o contiene m3u8 en la ruta
  if [[ "$STREAM_URL" =~ \.m3u8($|\?) || "$STREAM_URL" =~ "m3u8" ]]; then
    # Configuración optimizada para HLS (.m3u8)
    ffmpeg -rw_timeout 15000000 \
      -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
      -i "$STREAM_URL" \
      -c:v copy -c:a copy \
      -bsf:a aac_adtstoasc \
      -f flv "$1/$2"
  else
    # Configuración universal para otros flujos (RTSP, RTMP, HTTP MP4/TS)
    ffmpeg -rw_timeout 15000000 \
      -analyzeduration 10000000 -probesize 10000000 \
      -i "$STREAM_URL" \
      -c:v copy -c:a copy \
      -bsf:a aac_adtstoasc \
      -f flv "$1/$2"
  fi

  echo "Conexión perdida con la fuente. Reintentando en 5 segundos..."
  sleep 5
done
