# Dotfiles

Personal NixOS configuration with **Hyprland**, **Quickshell**, and **Home Manager**. Managed as a single Nix flake with two machine profiles.

![](https://imagedelivery.net/gC77PfJa-d3eBOxGPxtDxw/bc586556-0b7d-4aff-e4c1-4b949ab2b600/w=3440,h=1440)

## Overview

|                     |                                                                                                                                   |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **OS**              | NixOS (unstable), state version `25.05`                                                                                           |
| **Compositor**      | [Hyprland](https://hypr.land/) (Lua config via `hl.*` API)                                                                        |
| **Shell UI**        | [Quickshell](https://quickshell.org/) (`ii` panel family, based on [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)) |
| **Display manager** | [SDDM](https://github.com/sddm/sddm) with [SilentSDDM](https://github.com/uiriansan/SilentSDDM)                                   |
| **Terminal**        | [Kitty](https://github.com/kovidgoyal/kitty)                                                                                      |
| **Shell**           | Zsh + Oh My Zsh + [Starship](https://starship.rs/)                                                                                |
| **Editor**          | VS Code + [Cursor](https://cursor.com/) (via `code-cursor-nix`)                                                                   |
| **Layout**          | Dwindle tiling, 8px gaps, 18px rounding, blur + shadows                                                                           |
| **Keyboard**        | Polish (`pl`) layout                                                                                                              |
| **Locale**          | `en_US.UTF-8` + `pl_PL.UTF-8`, timezone `Europe/Warsaw`                                                                           |

## Hosts

Two flake outputs are defined in `flake.nix`:

| Host            | Flake output    | Hardware                                    | GPU module             | Notes                                                  |
| --------------- | --------------- | ------------------------------------------- | ---------------------- | ------------------------------------------------------ |
| **workstation** | `.#workstation` | AMD Ryzen 7 9700X, 32 GB RAM                | `nixos/gpu/nvidia.nix` | OpenSSH enabled; acts as remote builder for the laptop |
| **laptop**      | `.#laptop`      | HUAWEI MateBook 14, Ryzen 5 4600H, 8 GB RAM | `nixos/gpu/amd.nix`    | TLP + zram; offloads heavy builds to workstation       |

Shared host variables live in `hosts/<host>/variables.nix`. Per-host hardware config is in `hosts/<host>/hardware-configuration.nix`.

## Quick start

### Prerequisites

1. Clone this repo to `~/dotfiles` (Home Manager symlinks configs from that path).
2. Generate or copy `hardware-configuration.nix` for your machine into `hosts/<host>/`.
3. Adjust `hosts/<host>/variables.nix` (hostname, username, git identity).

### Apply configuration

```bash
# Workstation
sudo nixos-rebuild switch --flake ~/dotfiles#workstation

# Laptop
sudo nixos-rebuild switch --flake ~/dotfiles#laptop
```

### Format Nix files

```bash
nix fmt
```

## Repository structure

```
.
├── flake.nix                 # Root flake: inputs + host outputs
├── hosts/
│   ├── laptop/               # MateBook profile
│   └── workstation/          # Desktop profile
├── nixos/                    # Shared NixOS modules
│   ├── default.nix           # Boot, audio, locale, users, SDDM, ...
│   ├── distributed-build.nix # Laptop → workstation remote builds
│   ├── docker.nix
│   └── gpu/                  # amd.nix / nvidia.nix
├── home/                     # Shared Home Manager modules
│   ├── programs/             # git, zsh, kitty, vscode, direnv
│   └── system/               # hyprland, quickshell, theme, packages
├── dots/                     # Symlinked user configs (see home/lib.nix)
│   ├── hypr/                 # Hyprland Lua config
│   ├── quickshell/           # Quickshell QML shell + config.json
│   ├── btop/
│   └── qt5ct/
└── overlays/                 # spotify-adblock, quickshell-wrapper
```

Dotfiles under `dots/` are linked into `~/.config/` via `config.lib.custom.mkLinkDotfiles`, which creates out-of-store symlinks pointing at `~/dotfiles/dots/<path>`.

## Hyprland keybindings

Main modifier: **Super** (`SUPER`). Press **Super + N** anytime to open the in-shell cheatsheet (reads `dots/hypr/conf/keybindings.lua` live).

### Launch

| Key              | Action                                           |
| ---------------- | ------------------------------------------------ |
| `Super + Return` | Open terminal (Kitty)                            |
| `Super + D`      | Toggle application launcher (Quickshell)         |
| `Super + E`      | Open file manager (Dolphin)                      |
| `Super + F12`    | Screenshot full output to clipboard (`hyprshot`) |

### Quickshell

| Key         | Action                                                      |
| ----------- | ----------------------------------------------------------- |
| `Super + B` | Toggle right sidebar (quick settings, media, notifications) |
| `Super + N` | Open keybinding cheatsheet                                  |

Hold **Super** briefly to reveal workspace numbers on the bar (configured in Quickshell).

### Windows

| Key                 | Action                                          |
| ------------------- | ----------------------------------------------- |
| `Super + Shift + Q` | Close active window                             |
| `Super + M`         | Exit Hyprland (via `hyprshutdown` if available) |
| `Super + Shift + S` | Suspend system                                  |
| `Super + V`         | Toggle floating                                 |
| `Super + P`         | Toggle pseudo-tile                              |
| `Super + F`         | Toggle fullscreen                               |

### Focus

| Key               | Action                  |
| ----------------- | ----------------------- |
| `Super + ←/→/↑/↓` | Move focus in direction |

### Workspaces

| Key                    | Action                        |
| ---------------------- | ----------------------------- |
| `Super + 1..0`         | Switch to workspace 1–10      |
| `Super + Shift + 1..0` | Move window to workspace 1–10 |
| `Super + scroll down`  | Next workspace                |
| `Super + scroll up`    | Previous workspace            |

### Mouse

| Key           | Action        |
| ------------- | ------------- |
| `Super + LMB` | Drag window   |
| `Super + RMB` | Resize window |

Keybindings are defined in [`dots/hypr/conf/keybindings.lua`](dots/hypr/conf/keybindings.lua).

## Idle and power

[`dots/hypr/hypridle.conf`](dots/hypr/hypridle.conf):

| Timeout            | Action                  |
| ------------------ | ----------------------- |
| 5 min              | Turn off display (DPMS) |
| 30 min             | Suspend system          |
| Lid close (laptop) | Suspend                 |
| Power button       | Suspend                 |

Session lock is handled by Quickshell (`loginctl lock-session`).

## Hyprland config

Lua entry point: [`dots/hypr/hyprland.lua`](dots/hypr/hyprland.lua)

| File                   | Purpose                                    |
| ---------------------- | ------------------------------------------ |
| `conf/autostart.lua`   | Quickshell, hypridle, cliphist, D-Bus env  |
| `conf/environment.lua` | Monitor, cursor theme, Wayland/Qt env vars |
| `conf/theme.lua`       | Gaps, blur, shadows, animations            |
| `conf/settings.lua`    | Input (PL layout), dwindle, misc           |
| `conf/windowrules.lua` | Blur, tearing (games/Steam), layer rules   |
| `conf/keybindings.lua` | All keybinds                               |

Autostart on login:

- **Quickshell** (`qs -c ii`)
- **hypridle**
- **cliphist** (text + image clipboard history)

## Quickshell

Panel family `ii` with bar, launcher, lock screen, OSD, media controls, notification popups, on-screen keyboard, and right sidebar.

Config: [`dots/quickshell/config.json`](dots/quickshell/config.json)

Notable sidebar toggles (Android-style quick settings):

- Network, Bluetooth, idle inhibitor, mic, audio, night light

Bar utilities include dark mode toggle, keyboard layout indicator, and screenshot button.

## Applications

Installed via Home Manager (`home/system/packages.nix`):

| Category           | Apps                                                          |
| ------------------ | ------------------------------------------------------------- |
| **Browser**        | Brave (+ Bitwarden extension)                                 |
| **Communication**  | Discord (OpenASAR), Spotify (adblock overlay)                 |
| **Media**          | VLC, Gwenview                                                 |
| **Files**          | Dolphin, Proton VPN                                           |
| **Dev / CLI**      | Cursor, Postman, Docker Compose, fastfetch, btop, ripgrep, jq |
| **Hyprland tools** | hyprshot, hyprpicker, ydotool, wtype                          |
| **System**         | pavucontrol, lxappearance                                     |

Default MIME handlers: Brave (web/PDF), Gwenview (images), VLC (video).

## Theme and fonts

Dark Material-inspired setup (`home/system/theme.nix`):

| Element          | Value                                     |
| ---------------- | ----------------------------------------- |
| GTK theme        | Adwaita (adw-gtk3), dark                  |
| Icons            | Papirus-Dark                              |
| Cursor           | Bibata-Modern-Ice, 24px                   |
| Sans font        | Rubik                                     |
| Monospace        | JetBrains Mono Nerd Font                  |
| Quickshell fonts | Gabarito, Space Grotesk, Material Symbols |
| Terminal palette | Custom warm dark (Kitty)                  |

Wallpaper path is set in Quickshell config (`~/.config/quickshell/wallpaper.png`).

## Development setup

| Tool        | Config                                                                                  |
| ----------- | --------------------------------------------------------------------------------------- |
| **Git**     | Name/email from host `variables.nix`, default branch `master`                           |
| **direnv**  | Enabled with nix-direnv integration                                                     |
| **VS Code** | Nix IDE, Python, Vue/Volar, Tailwind, ESLint, Prettier, Docker, LaTeX, WakaTime, direnv |
| **Docker**  | Enabled on workstation; user in `docker` group                                          |

VS Code: format on save, ESLint fix on save, Material Icon Theme.

## NixOS services

Shared modules in `nixos/`:

- **Audio**: PipeWire + WirePlumber, low-latency profile, NoiseTorch
- **Networking**: NetworkManager, Cloudflare (`1.1.1.1`) + Quad9 DNS, port 3000 open
- **Bluetooth**, **GVFS**, **udisks2**, Android tools (MTP/adb)
- **nix**: flakes, weekly GC (7d retention), unfree packages allowed
- **SDDM**: SilentSDDM catppuccin-latte theme, custom dark overrides

## Distributed builds

The laptop offloads heavy builds (e.g. Quickshell/Qt) to the workstation over SSH. See [`nixos/distributed-build.nix`](nixos/distributed-build.nix).

Requirements:

1. Workstation reachable at `192.168.0.60` (SSH host alias `workstation-builder`).
2. Root's `/root/.ssh/id_ed25519` on the laptop; public key in `nei@workstation:~/.ssh/authorized_keys`.
3. Workstation user `nei` in `nix.settings.trusted-users`.

If the workstation is offline, Nix falls back to local builds after a 5s connect timeout.

## Flake inputs

| Input             | Purpose                                    |
| ----------------- | ------------------------------------------ |
| `nixpkgs`         | nixos-unstable                             |
| `home-manager`    | User environment                           |
| `hyprland`        | Compositor (pinned from hyprwm)            |
| `quickshell`      | Shell UI (pinned commit with Lua dispatch) |
| `silentSDDM`      | Login theme                                |
| `code-cursor-nix` | Cursor editor                              |
| `nixos-hardware`  | Hardware modules                           |

## Credits

- [end-4](https://github.com/end-4) for the Quickshell / dots-hyprland base
- [uiriansan](https://github.com/uiriansan) for SilentSDDM
- [sioodmy](https://github.com/sioodmy) for Nix configuration patterns
