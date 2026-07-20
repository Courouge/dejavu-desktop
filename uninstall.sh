#!/usr/bin/env bash
# Redmond Desktop — restaure les configurations d'origine.
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"

restore() {
  local dest="$1"
  if [ -e "$dest.redmond-backup" ]; then
    rm -rf "$dest"
    mv "$dest.redmond-backup" "$dest"
    echo "[redmond] Restauré : $dest"
  else
    rm -rf "$dest"
    echo "[redmond] Supprimé : $dest"
  fi
}

restore "$CONFIG_DIR/openbox"
restore "$CONFIG_DIR/tint2"
restore "$CONFIG_DIR/jgmenu"
restore "$CONFIG_DIR/picom.conf"
rm -f "$DATA_DIR/applications/redmond-menu.desktop"
rm -rf "$CONFIG_DIR/redmond"

echo "[redmond] Désinstallé. Les paquets et thèmes (~/.themes, ~/.icons) sont conservés ;"
echo "[redmond] supprimez-les manuellement si souhaité."
