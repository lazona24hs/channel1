#!/bin/bash

# URL del flujo HLS (.m3u8) que quieres retransmitir
M3U8_URL="http://200.59.213.66:8000/play/a01o/index.m3u8"

echo "Iniciando retransmisión desde fuente M3U8..."

while true; do
  # FFmpeg: Lectura directa sin transcodificación (-c copy)
  ffmpeg -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -re -i "$M3U8_URL" \
    -c:v copy -c:a copy \
    -f flv "$1/$2"

  echo "Conexión perdida con el M3U8. Reintentando en 5 segundos..."
  sleep 5
done
