# DejaVu Desktop

🇫🇷 [Version française](README.fr.md)

A Linux desktop that looks and feels like Windows — familiar taskbar, Start menu, theme, and keyboard shortcuts. *You already know this screen.*

**Made for**: people switching from Windows to Linux who want to keep their bearings from day one.

## What it looks like

**Family Edition (KDE)** — a full Windows 11-style desktop:

![DejaVu desktop: centered taskbar, Win11 icons, Bloom wallpaper](docs/screenshots/shot9-office-firefox.png)

The Start menu, with search and pinned apps:

![Windows 11-style Start menu](docs/screenshots/shot7-kde-win11-menu.png)

## Two editions

| Edition | Script | Base | Who it's for |
|---|---|---|---|
| **Family** (KDE) | `./install-kde.sh` | Ubuntu/Kubuntu + KDE Plasma | Full daily use (settings, Wi-Fi, printers built in) |
| **Lite** (Openbox) | `./install.sh` | Minimal Debian/Ubuntu + Openbox/tint2/jgmenu | Old PCs, end-of-support Windows 10 machines (~300 MB RAM) |

The Family Edition turns Plasma into a near-Windows 11 (validated on Ubuntu 24.04 Plasma 5 and 26.04 Plasma 6):
- **Win11OS** global theme + **Win11** icons (yeyushengfan258) + Bloom wallpaper
- **Windows 11 Start menu** (OnzeMenu plasmoid: search, pinned/recommended apps)
- **centered taskbar** with pinned apps (file manager, Firefox, LibreOffice, settings)
- Win11 window decorations, **double-click to open**, themed login and lock screens
- **office essentials included**: LibreOffice, Okular (PDF), Gwenview (photos), Ark (archives), Kate, calculator
- **automatic updates**: Discover (tray notifications, Windows Update-style) + unattended security upgrades
- **familiar names**: Dolphin becomes "File Explorer", Konsole "Terminal", Kate "Notepad", KCalc "Calculator", Okular "PDF Reader", Gwenview "Photos", Ark "Archives" (French labels by default)

## System requirements

| | Family Edition (KDE) | Lite Edition (Openbox) |
|---|---|---|
| Processor | 64-bit (x86_64), dual-core | 64-bit (x86_64) |
| RAM | 4 GB minimum, 8 GB comfortable | 2 GB (~300 MB used at idle) |
| Disk space | 30 GB | 10 GB |
| Other | Internet connection during install | Internet connection during install |

Any PC that ran Windows 10 meets the Lite Edition requirements; most PCs from 2012 onwards handle the Family Edition.

## Install from scratch (starting from a Windows PC)

1. **Back up your files** (USB drive or cloud) — the installation can erase the disk.
2. **Download an Ubuntu 26.04 LTS ISO** from [ubuntu.com/download](https://ubuntu.com/download/desktop).
3. **Create a bootable USB stick** (8 GB+) with [balenaEtcher](https://etcher.balena.io/) or [Rufus](https://rufus.ie/): pick the ISO, pick the USB stick, write.
4. **Boot the PC on the USB stick**: restart and press the boot-menu key (usually `F12`, `F9`, `Esc`, or `F2` depending on the brand), then choose the USB drive.
5. **Install Ubuntu**: follow the wizard — language, keyboard, then "Erase disk and install Ubuntu" (or install alongside Windows if you want to keep it). Create your user account and let it finish, then reboot.
6. **Install DejaVu Desktop**: once on the Ubuntu desktop, open a terminal (`Ctrl+Alt+T`) and run:

   ```bash
   sudo apt install -y git
   git clone https://github.com/Courouge/dejavu-desktop.git
   cd dejavu-desktop
   ./install-kde.sh          # installs KDE, office apps, updates (10-20 min)
   ```

7. **Switch to the Plasma session**: log out, click the session icon on the login screen, pick **"Plasma (X11)"**, and log back in.
8. **Apply the Windows look**: run `./install-kde.sh` once more from the new session. Done — the desktop now looks like the screenshots above.

Already on Debian 12+/Ubuntu 22.04+? Skip to step 6. For the Lite Edition on an old PC, run `./install.sh` instead and pick the "Openbox" session.

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

## License

MIT - see [LICENSE](LICENSE).
