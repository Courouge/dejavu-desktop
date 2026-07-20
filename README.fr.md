# DejaVu Desktop

🇬🇧 [English version](README.md)

Un bureau Linux qui imite l'apparence de Windows — barre des tâches, menu Démarrer, thème et raccourcis familiers. *Vous connaissez déjà cet écran.*

**Public visé** : les personnes qui migrent de Windows vers Linux et veulent retrouver leurs repères immédiatement.

## À quoi ça ressemble

**Édition Familiale (KDE)** — bureau complet façon Windows 11 :

![Bureau DejaVu : barre des tâches centrée, icônes Win11, fond Bloom](docs/screenshots/shot9-office-firefox.png)

Le menu Démarrer, avec recherche et applications épinglées :

![Menu Démarrer style Windows 11](docs/screenshots/shot7-kde-win11-menu.png)

## Deux éditions

| Édition | Script | Base | Pour qui |
|---|---|---|---|
| **Familiale** (KDE) | `./install-kde.sh` | Ubuntu/Kubuntu + KDE Plasma | Usage quotidien complet (paramètres, Wi-Fi, imprimantes intégrés) |
| **Lite** (Openbox) | `./install.sh` | Debian/Ubuntu minimal + Openbox/tint2/jgmenu | Vieux PC, machines Windows 10 en fin de support (~300 Mo RAM) |

L'édition Familiale transforme Plasma en quasi-Windows 11 (recette validée sur Ubuntu 24.04) :
- thème global **Win11OS** + icônes **Win11** (yeyushengfan258) + fond d'écran Bloom
- **menu Démarrer Windows 11** (plasmoïde OnzeMenu : recherche, applications épinglées/recommandées)
- **barre des tâches centrée** avec applications épinglées (explorateur, Firefox, LibreOffice, paramètres)
- décorations de fenêtres Win11, **double-clic pour ouvrir**, écrans de connexion et de verrouillage thémés
- **bureautique incluse** : LibreOffice (fr), Okular (PDF), Gwenview (images), Ark (archives), Kate, calculatrice
- **mises à jour automatiques** : Discover (notifications façon Windows Update) + correctifs de sécurité sans intervention
- **noms familiers** : Dolphin devient « Explorateur de fichiers », Konsole « Terminal », Kate « Bloc-notes », KCalc « Calculatrice », Okular « Lecteur PDF », Gwenview « Photos », Ark « Archives »

## Prérequis matériels

| | Édition Familiale (KDE) | Édition Lite (Openbox) |
|---|---|---|
| Processeur | 64 bits (x86_64), double cœur | 64 bits (x86_64) |
| Mémoire (RAM) | 4 Go minimum, 8 Go confortable | 2 Go (~300 Mo utilisés au repos) |
| Espace disque | 30 Go | 10 Go |
| Autre | Connexion internet pendant l'installation | Connexion internet pendant l'installation |

Tout PC qui faisait tourner Windows 10 satisfait l'édition Lite ; la plupart des PC à partir de 2012 gèrent l'édition Familiale.

## Installer from scratch (depuis un PC sous Windows)

1. **Sauvegardez vos fichiers** (clé USB ou cloud) — l'installation peut effacer le disque.
2. **Téléchargez l'ISO d'Ubuntu 24.04 LTS** sur [ubuntu.com/download](https://ubuntu.com/download/desktop).
3. **Créez une clé USB d'installation** (8 Go ou plus) avec [balenaEtcher](https://etcher.balena.io/) ou [Rufus](https://rufus.ie/) : choisir l'ISO, choisir la clé, écrire.
4. **Démarrez le PC sur la clé** : redémarrez et pressez la touche du menu de démarrage (souvent `F12`, `F9`, `Échap` ou `F2` selon la marque), puis choisissez la clé USB.
5. **Installez Ubuntu** : suivez l'assistant — langue, clavier, puis « Effacer le disque et installer Ubuntu » (ou installer à côté de Windows pour le conserver). Créez votre compte, laissez finir, redémarrez.
6. **Installez DejaVu Desktop** : une fois sur le bureau Ubuntu, ouvrez un terminal (`Ctrl+Alt+T`) et tapez :

   ```bash
   sudo apt install -y git
   git clone https://github.com/Courouge/dejavu-desktop.git
   cd dejavu-desktop
   ./install-kde.sh          # installe KDE, la bureautique, les mises à jour (10-20 min)
   ```

7. **Basculez sur la session Plasma** : déconnectez-vous, cliquez sur l'icône de session sur l'écran de connexion, choisissez **« Plasma (X11) »**, reconnectez-vous.
8. **Appliquez l'habillage Windows** : relancez `./install-kde.sh` depuis la nouvelle session. Terminé — le bureau ressemble aux captures ci-dessus.

Déjà sous Debian 12+/Ubuntu 22.04+ ? Passez directement à l'étape 6. Pour l'édition Lite sur un vieux PC : `./install.sh` puis session « Openbox ».

## Raccourcis clavier (identiques à Windows)

| Raccourci | Action |
|---|---|
| `Super` | Menu Démarrer |
| `Super + E` | Explorateur de fichiers |
| `Super + D` | Afficher le bureau |
| `Super + L` | Verrouiller l'écran |
| `Super + ←/→` | Ancrer la fenêtre à gauche/droite |
| `Alt + Tab` | Changer de fenêtre |
| `Alt + F4` | Fermer la fenêtre |

## Édition Lite : composants et personnalisation

| Rôle | Outil |
|---|---|
| Gestionnaire de fenêtres | Openbox |
| Barre des tâches (+ zone de notification, horloge) | tint2 |
| Menu Démarrer | jgmenu |
| Effets (ombres, transparence) | picom |
| Fond d'écran | feh |
| Thème GTK + icônes | B00merang Windows-10 |
| Gestionnaire de fichiers | Thunar |
| Réseau / volume / notifications | nm-applet, volumeicon, dunst |

- Barre des tâches : `~/.config/tint2/tint2rc` — Menu : `~/.config/jgmenu/jgmenurc`
- Raccourcis / fenêtres : `~/.config/openbox/rc.xml`
- Fond d'écran : placer une image dans `~/.config/dejavu/wallpaper.jpg`
- Apparence GTK : lancer `lxappearance`

## Notes VM / matériel

- Dans une VM sans GPU : picom doit passer en backend `xrender` (édition Lite).
- Les images cloud Debian/Ubuntu utilisent un noyau allégé **sans pilotes DRM** : installer `linux-generic` (Ubuntu) ou `linux-image-amd64` (Debian) pour l'affichage virtio/qxl.
- Préférer un display manager (LightDM/SDDM) à `startx` lancé par systemd.

## Désinstallation

```bash
./uninstall.sh
```

Restaure les configurations sauvegardées (`*.dejavu-backup`).

## Marques

Projet indépendant, non affilié à Microsoft. Aucune ressource propriétaire (icônes, polices, logos Windows) n'est distribuée : seuls des thèmes libres d'inspiration similaire sont utilisés.

## Licence

MIT - voir [LICENSE](LICENSE).
