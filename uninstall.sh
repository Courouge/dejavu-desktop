#!/usr/bin/env bash
# DejaVu Desktop — restaure les configurations d'origine.
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"

restore() {
  local dest="$1"
  if [ -e "$dest.dejavu-backup" ]; then
    rm -rf "$dest"
    mv "$dest.dejavu-backup" "$dest"
    echo "[dejavu] Restauré : $dest"
  else
    rm -rf "$dest"
    echo "[dejavu] Supprimé : $dest"
  fi
}

restore "$CONFIG_DIR/openbox"
restore "$CONFIG_DIR/tint2"
restore "$CONFIG_DIR/jgmenu"
restore "$CONFIG_DIR/picom.conf"
rm -f "$DATA_DIR/applications/dejavu-menu.desktop"
rm -rf "$CONFIG_DIR/dejavu"

echo "[dejavu] Désinstallé. Les paquets et thèmes (~/.themes, ~/.icons) sont conservés ;"
echo "[dejavu] supprimez-les manuellement si souhaité."
