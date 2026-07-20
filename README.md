# DejaVu Desktop

🇫🇷 [Version française](README.fr.md)

A Linux desktop that looks and feels like Windows — familiar taskbar, Start menu, theme, and keyboard shortcuts. *You already know this screen.*

**Made for**: people switching from Windows to Linux who want to keep their bearings from day one.

## What it looks like

**Family Edition (KDE)** — a full Windows 11-style desktop:

![DejaVu desktop: centered taskbar, Win11 icons, Bloom wallpaper](docs/screenshots/shot9-office-firefox.png)

The Start menu, with search and pinned apps:

![Windows 11-style Start menu](docs/screenshots/shot7-kde-win11-menu.png)

**Lite Edition (Openbox)** — the same promise for old PCs:

![Lite Edition: Openbox + tint2, taskbar and windows](docs/screenshots/shot2-windows.png)

## Two editions

| Edition | Script | Base | Who it's for |
|---|---|---|---|
| **Family** (KDE) | `./install-kde.sh` | Ubuntu/Kubuntu + KDE Plasma | Full daily use (settings, Wi-Fi, printers built in) |
| **Lite** (Openbox) | `./install.sh` | Minimal Debian/Ubuntu + Openbox/tint2/jgmenu | Old PCs, end-of-support Windows 10 machines (~300 MB RAM) |

The Family Edition turns Plasma into a near-Windows 11 (recipe validated on Ubuntu 24.04):
- **Win11OS** global theme + **Win11** icons (yeyushengfan258) + Bloom wallpaper
- **Windows 11 Start menu** (OnzeMenu plasmoid: search, pinned/recommended apps)
- **centered taskbar** with pinned apps (file manager, Firefox, LibreOffice, terminal, settings)
- Win11 window decorations, **double-click to open**, themed login and lock screens
- **office essentials included**: LibreOffice, Okular (PDF), Gwenview (photos), Ark (archives), Kate, calculator

## Installation

Supported distributions: **Debian 12+, Ubuntu 22.04+** (and derivatives).

```bash
git clone https://github.com/Courouge/dejavu-desktop.git
cd dejavu-desktop

# Family Edition (recommended)
./install-kde.sh
# then log out, pick the "Plasma (X11)" session, and run ./install-kde.sh again

# OR Lite Edition (old PCs)
./install.sh
# then log out and pick the "Openbox" session
```

## Keyboard shortcuts (same as Windows)

| Shortcut | Action |
|---|---|
| `Super` | Start menu |
| `Super + E` | File explorer |
| `Super + D` | Show desktop |
| `Super + L` | Lock screen |
| `Super + ←/→` | Snap window left/right |
| `Alt + Tab` | Switch windows |
| `Alt + F4` | Close window |

## Lite Edition: components and customization

| Role | Tool |
|---|---|
| Window manager | Openbox |
| Taskbar (+ system tray, clock) | tint2 |
| Start menu | jgmenu |
| Effects (shadows, transparency) | picom |
| Wallpaper | feh |
| GTK theme + icons | B00merang Windows-10 |
| File manager | Thunar |
| Network / volume / notifications | nm-applet, volumeicon, dunst |

- Taskbar: `~/.config/tint2/tint2rc` — Menu: `~/.config/jgmenu/jgmenurc`
- Shortcuts / windows: `~/.config/openbox/rc.xml`
- Wallpaper: drop an image at `~/.config/dejavu/wallpaper.jpg`
- GTK appearance: run `lxappearance`

## VM / hardware notes

- In a VM without GPU: switch picom to the `xrender` backend (Lite Edition).
- Debian/Ubuntu cloud images ship a trimmed kernel **without DRM drivers**: install `linux-generic` (Ubuntu) or `linux-image-amd64` (Debian) for virtio/qxl display.
- Prefer a display manager (LightDM/SDDM) over `startx` launched from systemd.

## Uninstall

```bash
./uninstall.sh
```

Restores the backed-up configurations (`*.dejavu-backup`).

## Trademarks

Independent project, not affiliated with Microsoft. No proprietary assets (Windows icons, fonts, logos) are distributed: only free themes with a similar look are used.
