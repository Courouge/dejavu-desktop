#!/usr/bin/env bash
# Redmond Desktop — installation d'un bureau Openbox imitant Windows.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"

PACKAGES=(
  openbox obconf tint2 jgmenu picom feh thunar
  lxappearance network-manager-gnome volumeicon-alsa dunst
  xdg-utils x11-xserver-utils policykit-1-gnome light-locker scrot git
)

log()  { printf '\033[1;34m[redmond]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[redmond]\033[0m %s\n' "$*" >&2; }

require_debian() {
  if ! command -v apt-get >/dev/null 2>&1; then
    err "Distribution non supportée : apt-get introuvable (Debian/Ubuntu requis)."
    exit 1
  fi
}

install_packages() {
  log "Installation des paquets (sudo requis)…"
  sudo apt-get update
  sudo apt-get install -y "${PACKAGES[@]}"
}

backup_and_copy() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -e "$dest.redmond-backup" ]; then
    mv "$dest" "$dest.redmond-backup"
    log "Sauvegarde : $dest -> $dest.redmond-backup"
  fi
  mkdir -p "$(dirname "$dest")"
  cp -r "$src" "$dest"
}

install_configs() {
  log "Copie des configurations…"
  backup_and_copy "$REPO_DIR/config/openbox" "$CONFIG_DIR/openbox"
  backup_and_copy "$REPO_DIR/config/tint2"   "$CONFIG_DIR/tint2"
  backup_and_copy "$REPO_DIR/config/jgmenu"  "$CONFIG_DIR/jgmenu"
  backup_and_copy "$REPO_DIR/config/picom.conf" "$CONFIG_DIR/picom.conf"
  chmod +x "$CONFIG_DIR/openbox/autostart"
  mkdir -p "$CONFIG_DIR/redmond"
  mkdir -p "$DATA_DIR/applications"
  cp "$REPO_DIR/assets/redmond-menu.desktop" "$DATA_DIR/applications/"
}

install_themes() {
  mkdir -p "$THEMES_DIR" "$ICONS_DIR"
  if [ ! -d "$THEMES_DIR/Windows-10" ]; then
    log "Téléchargement du thème GTK Windows-10 (B00merang)…"
    git clone --depth 1 https://github.com/B00merang-Project/Windows-10.git \
      "$THEMES_DIR/Windows-10"
  fi
  if [ ! -d "$ICONS_DIR/Windows-10" ]; then
    log "Téléchargement du thème d'icônes Windows-10 (B00merang)…"
    git clone --depth 1 https://github.com/B00merang-Artwork/Windows-10.git \
      "$ICONS_DIR/Windows-10"
  fi

  log "Application du thème GTK…"
  mkdir -p "$CONFIG_DIR/gtk-3.0"
  cat > "$CONFIG_DIR/gtk-3.0/settings.ini" <<'EOF'
[Settings]
gtk-theme-name=Windows-10
gtk-icon-theme-name=Windows-10
gtk-font-name=Sans 10
EOF
  cat > "$HOME/.gtkrc-2.0" <<'EOF'
gtk-theme-name="Windows-10"
gtk-icon-theme-name="Windows-10"
gtk-font-name="Sans 10"
EOF
}

main() {
  require_debian
  install_packages
  install_configs
  install_themes
  log "Terminé. Déconnectez-vous et choisissez la session « Openbox »."
  log "Fond d'écran personnalisé : placez une image dans $CONFIG_DIR/redmond/wallpaper.jpg"
}

main "$@"
