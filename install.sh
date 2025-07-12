#!/bin/bash

# Ruta donde está el script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
HOME_DIR="$HOME"

echo "📁 Dotfiles desde: $SCRIPT_DIR"
echo "🔗 Enlazando a: $CONFIG_DIR y $HOME_DIR"

# Asegura que ~/.config existe
mkdir -p "$CONFIG_DIR"

# Enlazar directorios en .config
for dir in "$SCRIPT_DIR"/*/; do
    name=$(basename "$dir")

    # Evitar carpetas que no deben enlazarse
    [[ "$name" == ".git" ]] && continue

    echo "📂 Enlazando directorio $name → $CONFIG_DIR/$name"
    ln -sfn "$dir" "$CONFIG_DIR/$name"
done


# Enlazar archivos individuales
for file in "$SCRIPT_DIR"/.* "$SCRIPT_DIR"/*.conf; do
    filename=$(basename "$file")

    # Saltar si no es un archivo regular
    [[ ! -f "$file" ]] && continue

    case "$filename" in
        .bashrc | .zshrc | .bash_profile | .bash_logout )
            echo "📄 Enlazando $filename → $HOME_DIR/$filename"
            ln -sfn "$file" "$HOME_DIR/$filename"
            ;;
        *.conf )
            echo "📄 Enlazando $filename → $CONFIG_DIR/$filename"
            ln -sfn "$file" "$CONFIG_DIR/$filename"
            ;;
        * )
            # Saltar otros archivos ocultos o temporales
            ;;
    esac
done

echo "✅ Todos los enlaces han sido creados."
