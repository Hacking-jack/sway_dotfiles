#!/bin/bash

# Lista personalizada de apps con emojis
apps=$(cat <<EOF
🌐 Firefox
📝 Gedit
📁 Archivos
🎵 Música
🖼️ Imágenes
🖥️ Terminal
EOF
)

# Mostrar el menú
choice=$(echo "$apps" | wofi --dmenu --allow-markup --prompt "📦 Mis Aplicaciones")

# Ejecutar según elección
case "$choice" in
  "🌐 Firefox")     firefox ;;
  "📝 Gedit")       micro ;;
  "📁 Archivos")    nautilus ;;
  "🎵 Música")      spotify ;;
  "🖼️ Imágenes")    firefox;;
  "🖥️ Terminal")    foot ;;
esac
