#!/usr/bin/env bash
# ~/.local/bin/build-blackarch-apps.sh

DEST=~/.local/share/applications/blackarch-gui
mkdir -p "$DEST"
rm -f "$DEST"/*.desktop

for pkg in $(pacman -Qg | awk '/^blackarch-/{print $2}' | sort -u); do
  # archivos .desktop que pertenecen a ese paquete
  pacman -Ql "$pkg" 2>/dev/null | awk '/\.desktop$/{print $2}' | while read -r f; do
    [ -f "$f" ] && cp "$f" "$DEST/"
  done
done

echo "Copiados $(ls "$DEST" | wc -l) lanzadores GUI de BlackArch"
