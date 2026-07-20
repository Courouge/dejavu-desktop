#!/usr/bin/env bash
# Redmond Desktop — édition familiale : KDE Plasma déguisé en Windows 11.
# Cible : Ubuntu 22.04+/Kubuntu/Debian 12+ avec Plasma disponible.
# Recette validée le 2026-07-20 sur Ubuntu 24.04 (Plasma 5.27) en VM.
set -euo pipefail

LNF_ID="com.github.yeyushengfan258.Win11OS-dark"
ICON_THEME="Win11"
TMPD=""

log() { printf '\033[1;34m[redmond-kde]\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m[redmond-kde]\033[0m %s\n' "$*" >&2; }
cleanup() { [ -n "$TMPD" ] && rm -rf "$TMPD"; }
trap cleanup EXIT

require_apt() {
  command -v apt-get >/dev/null 2>&1 || { err "apt-get introuvable."; exit 1; }
}

install_plasma() {
  if command -v plasmashell >/dev/null 2>&1; then
    log "KDE Plasma déjà installé."
  else
    log "Installation de KDE Plasma (sudo requis, plusieurs minutes)…"
    sudo apt-get update
    sudo apt-get install -y plasma-desktop sddm systemsettings \
      dolphin konsole kscreen plasma-nm plasma-pa firefox git
  fi
  # quicklaunch (requis par OnzeMenu) + outils
  sudo apt-get install -y plasma-widgets-addons git kpackagetool5 2>/dev/null || \
    sudo apt-get install -y kdeplasma-addons git
}

download_themes() {
  TMPD="$(mktemp -d)"
  log "Téléchargement des thèmes (dépôts libres GitHub)…"
  git clone --depth 1 https://github.com/yeyushengfan258/Win11OS-kde.git "$TMPD/win11os"
  git clone --depth 1 https://github.com/yeyushengfan258/Win11-icon-theme.git "$TMPD/win11icons"
  git clone --depth 1 https://github.com/adhec/OnzeMenuKDE.git "$TMPD/onzemenu"
}

install_themes() {
  log "Installation thème global + icônes + menu Win11…"
  (cd "$TMPD/win11os" && bash ./install.sh)
  (cd "$TMPD/win11icons" && bash ./install.sh)
  local pkgdir
  pkgdir=$(dirname "$(find "$TMPD/onzemenu" -maxdepth 4 -name 'metadata.desktop' -o -maxdepth 4 -name 'metadata.json' | head -1)")
  kpackagetool5 -t Plasma/Applet -i "$pkgdir" 2>/dev/null || \
    kpackagetool5 -t Plasma/Applet -u "$pkgdir"
  local wall="$TMPD/win11os/wallpaper/Win11OS-light/contents/images/3840x2400.jpg"
  if [ -f "$wall" ]; then
    mkdir -p "$HOME/.local/share/redmond"
    cp "$wall" "$HOME/.local/share/redmond/wallpaper.jpg"
  fi
}

install_sddm_theme() {
  # Écran de connexion façon Windows 11 (optionnel, nécessite sudo)
  if [ -d "$TMPD/win11os/sddm-dark/5.0/Win11OS-dark" ]; then
    log "Écran de connexion SDDM Win11…"
    sudo cp -r "$TMPD/win11os/sddm-dark/5.0/Win11OS-dark" /usr/share/sddm/themes/
    sudo mkdir -p /etc/sddm.conf.d
    printf '[Theme]\nCurrent=Win11OS-dark\n' | sudo tee /etc/sddm.conf.d/10-redmond-theme.conf >/dev/null
  fi
}

apply_theme() {
  if ! pgrep -x plasmashell >/dev/null 2>&1; then
    log "Session Plasma inactive : relancez ce script depuis le bureau Plasma pour appliquer le thème."
    return
  fi
  log "Application du thème, des icônes, du fond d'écran et des comportements Windows…"
  local kw
  kw="$(command -v kwriteconfig6 || command -v kwriteconfig5)"
  lookandfeeltool -a "$LNF_ID" || err "Échec application du thème global."
  "$kw" --file kdeglobals --group Icons --key Theme "$ICON_THEME" || true
  # Décorations de fenêtres Win11 + double-clic pour ouvrir (habitude Windows)
  "$kw" --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae
  "$kw" --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__Win11OS-dark
  "$kw" --file kdeglobals --group KDE --key SingleClick false
  dbus-send --session --dest=org.kde.KWin /KWin org.kde.KWin.reconfigure 2>/dev/null || true
  [ -f "$HOME/.local/share/redmond/wallpaper.jpg" ] && \
    plasma-apply-wallpaperimage "$HOME/.local/share/redmond/wallpaper.jpg" || true
}

apply_panel_layout() {
  # Barre des tâches centrée façon Win11 : menu OnzeMenu + applis épinglées.
  pgrep -x plasmashell >/dev/null 2>&1 || return 0
  log "Configuration du panneau (menu Win11, barre centrée, épinglage)…"
  local js='
var ps = panels();
var p = null;
for (var i = 0; i < ps.length; i++) { if (ps[i].location == "bottom") { p = ps[i]; break; } }
if (p) {
  var widgets = p.widgets();
  var tm = null, hasMenu = false;
  for (var i = 0; i < widgets.length; i++) {
    var w = widgets[i];
    if (w.type == "org.kde.plasma.kickoff") { w.remove(); }
    if (w.type == "org.kde.plasma.icontasks") { tm = w; }
    if (w.type == "OnzeMenu") { hasMenu = true; }
  }
  if (!hasMenu) {
    var s1 = p.addWidget("org.kde.plasma.panelspacer");
    var menu = p.addWidget("OnzeMenu");
    var s2 = p.addWidget("org.kde.plasma.panelspacer");
    menu.currentConfigGroup = ["General"];
    menu.writeConfig("icon", "start-here");
    if (tm) {
      tm.currentConfigGroup = ["General"];
      tm.writeConfig("launchers", "applications:org.kde.dolphin.desktop,applications:firefox.desktop,applications:org.kde.konsole.desktop,applications:systemsettings.desktop");
    }
    s1.index = 0; menu.index = 1; if (tm) { tm.index = 2; } s2.index = 3;
  }
}'
  dbus-send --print-reply --session --dest=org.kde.plasmashell \
    /PlasmaShell org.kde.PlasmaShell.evaluateScript string:"$js" >/dev/null || true
  # Redémarrage du shell
  (kquitapp5 plasmashell 2>/dev/null || kquitapp6 plasmashell 2>/dev/null || true
   sleep 2
   setsid plasmashell --replace >/dev/null 2>&1 &) || true
}

main() {
  require_apt
  install_plasma
  download_themes
  install_themes
  install_sddm_theme
  apply_theme
  apply_panel_layout
  log "Terminé. Si Plasma vient d'être installé : déconnectez-vous, choisissez la"
  log "session « Plasma (X11) », puis relancez ce script pour appliquer le thème."
}

main "$@"
