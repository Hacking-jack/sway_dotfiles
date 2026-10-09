#!/usr/bin/env bash
# blackarch-menu.sh

# Elegir categoría
cat=$(pacman -Sg | grep '^blackarch-' | sort | wofi --dmenu --prompt "Categoría BlackArch")
[ -z "$cat" ] && exit 0

# Elegir herramienta dentro de la categoría
tool=$(pacman -Sg "$cat" | awk '{print $2}' | sort | wofi --dmenu --prompt "$cat")
[ -z "$tool" ] && exit 0

# Lanzar en terminal (ajusta a tu terminal, ej. foot/kitty/alacritty)
foot -e bash -c "echo 'Ejecutando: $tool'; $tool; read -p 'Pulsa Enter para cerrar'"
