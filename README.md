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
| **Editor**          | [Neovim](https://neovim.io/) ([NvChad](https://nvchad.com/), default `$EDITOR`), VS Code, [Cursor](https://cursor.com/)           |
| **Layout**          | Dwindle tiling, 8px gaps, 18px rounding, blur + shadows                                                                           |
| **Keyboard**        | Polish (`pl`) layout                                                                                                              |
| **Locale**          | `en_US.UTF-8` + `pl_PL.UTF-8`, timezone `Europe/Warsaw`                                                                           |

## Hosts

Two flake outputs are defined in `flake.nix`, each built from `hosts/<host>/flake.nix`:

| Host            | Flake output    | Hardware                                    | GPU module             | Notes                                                                   |
| --------------- | --------------- | ------------------------------------------- | ---------------------- | ----------------------------------------------------------------------- |
| **workstation** | `.#workstation` | AMD Ryzen 7 9700X, 32 GB RAM                | `nixos/gpu/nvidia.nix` | OpenSSH enabled; remote builder for the laptop; Docker; libvirt/KVM VMs |
| **laptop**      | `.#laptop`      | HUAWEI MateBook 14, Ryzen 5 4600H, 8 GB RAM | `nixos/gpu/amd.nix`    | TLP + zram; offloads heavy builds to workstation                        |

Shared host variables live in `hosts/<host>/variables.nix` (hostname, username, git identity, locale, `isLaptop`). Per-host hardware config is in `hosts/<host>/hardware-configuration.nix`.

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
│   ├── laptop/               # MateBook profile (flake.nix, configuration.nix, variables.nix, home.nix)
│   └── workstation/          # Desktop profile
├── nixos/                    # Shared NixOS modules
│   ├── default.nix           # Imports the modules below, networking, DNS
│   ├── boot.nix              # GRUB (EFI, os-prober) + Plymouth, quiet boot
│   ├── audio.nix             # PipeWire low-latency, NoiseTorch
│   ├── sddm.nix              # SilentSDDM theme overrides
│   ├── power.nix             # logind keys, deep sleep; TLP + zram on the laptop
│   ├── performance.nix       # Responsiveness tuning (oomd, ananicy, scx, zram sysctls)
│   ├── distributed-build.nix # Laptop → workstation remote builds
│   ├── docker.nix            # Docker (workstation)
│   ├── virtualisation.nix    # libvirt/QEMU + virt-manager (workstation)
│   ├── claude-code-update.nix # Weekly Claude Code bump + switch (workstation)
│   └── gpu/                  # amd.nix / nvidia.nix
├── home/                     # Shared Home Manager modules
│   ├── lib.nix               # mkLinkDotfiles helper
│   ├── programs/             # git, zsh, kitty, neovim, vscode, obs, direnv, virt-manager
│   └── system/               # hyprland, quickshell, theme, packages
├── dots/                     # Symlinked user configs (see home/lib.nix)
│   ├── hypr/                 # Hyprland Lua config + hypridle.conf
│   ├── nvim/                 # Neovim (NvChad) config
│   ├── quickshell/           # Quickshell QML shell + config.json + wallpaper
│   ├── btop/
│   └── qt5ct/
└── overlays/                 # spotify-adblock, obsidian, quickshell-wrapper
```

Dotfiles under `dots/` are linked into `~/.config/` via `config.lib.custom.mkLinkDotfiles`, which creates out-of-store symlinks pointing at `~/dotfiles/dots/<path>`. Edits take effect without a rebuild.

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

Hold **Super** briefly to reveal workspace numbers on the bar (`showNumberDelay` in Quickshell config).

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

| Trigger            | Action  |
| ------------------ | ------- |
| 30 min idle        | Suspend |
| Lid close (laptop) | Suspend |
| Power button       | Suspend |

There is no DPMS blanking step: NVIDIA + high-refresh monitors tend to flap on/off with it.

Session lock is Quickshell's lock screen. `loginctl lock-session` (suspend, session menu) makes hypridle run `qs -p ~/dotfiles/dots/quickshell/ii ipc call lock activate`, and `inhibit_sleep = 3` holds suspend until the session is locked, so the desktop never flashes on resume.

## Hyprland config

Lua entry point: [`dots/hypr/hyprland.lua`](dots/hypr/hyprland.lua)

| File                   | Purpose                                                                                      |
| ---------------------- | -------------------------------------------------------------------------------------------- |
| `conf/autostart.lua`   | Quickshell, hypridle, cliphist, D-Bus env                                                    |
| `conf/environment.lua` | Monitor, cursor theme, Wayland/Qt env vars                                                   |
| `conf/host.lua`        | Hostname detection (`/etc/hostname`); laptop gets cheaper blur and no colour-management pass |
| `conf/theme.lua`       | Gaps, blur, shadows, animations                                                              |
| `conf/settings.lua`    | Input (PL layout), dwindle, misc, render                                                     |
| `conf/windowrules.lua` | Blur, tearing (games/Steam), layer rules                                                     |
| `conf/keybindings.lua` | All keybinds                                                                                 |

Autostart on login (wrapped in `setpriv --ambient-caps -all` so Quickshell/Flatpak apps launch correctly on NixOS):

- **Quickshell** (`qs -p ~/dotfiles/dots/quickshell/ii`, the canonical path starts faster than `-c ii` through the Home Manager symlinks; pass the same `-p` to `qs ipc` and `qs log`)
- **hypridle**
- **cliphist** (text + image clipboard history)

## Quickshell

Panel family `ii` with bar, launcher, lock screen, session screen, OSD, media controls, notification popups, polkit agent, screen corners, cheatsheet, and right sidebar.

Config: [`dots/quickshell/config.json`](dots/quickshell/config.json)

Notable sidebar toggles (Android-style quick settings):

- Network, Bluetooth, idle inhibitor, mic, audio, night light

Night light (`hyprsunset`) runs automatically from 19:00 to 06:30 at 2835 K.

Bar utilities: region screenshot, colour picker (`hyprpicker`) and mic mute.

## Neovim

[NvChad](https://nvchad.com/) v2.5 on top of lazy.nvim, configured in [`dots/nvim/`](dots/nvim/). Neovim is the default `$EDITOR` with `vi`/`vim` aliases (`home/programs/neovim.nix`).

- **Plugins** are managed by lazy.nvim; `lazy-lock.json` is tracked and writable thanks to the out-of-store symlink.
- **LSP servers and formatters** come from nixpkgs, not Mason (Mason's prebuilt binaries don't run on NixOS): `lua_ls`, `nil` (nixfmt), `html`/`cssls`/`jsonls`, `ts_ls`, `pyright`, `bashls`, `clangd`, `qmlls`.
- **Formatting** via conform.nvim on save: stylua, nixfmt, ruff, shfmt, clang-format, prettierd.
- **Theme**: base46 `rosepine` with transparency.
- **C/C++ workflow** (`lua/configs/cpp.lua`) for Makefile-driven single-file projects: build to quickfix, run in an NvChad terminal, auto-generate `compile_commands.json` for clangd.
- **Debugging** (`lua/configs/dap.lua`): nvim-dap + nvim-dap-ui with gdb's built-in DAP server (`gdb -i dap`, gdb ≥ 14 from the project's nix shell).

| Key                  | Action                                              |
| -------------------- | --------------------------------------------------- |
| `Space` (leader)     | NvChad mappings (`<leader>ch` opens the cheatsheet) |
| `;`                  | Enter command mode                                  |
| `jk` (insert)        | Escape                                              |
| `<leader>cc`         | C++: build current file                             |
| `<leader>cr`         | C++: build and run current file                     |
| `<leader>cs`         | C++: run without sanitizers                         |
| `<leader>ci`         | C++: toggle inlay hints                             |
| `F5` / `<leader>dc`  | DAP: launch / continue                              |
| `F9` / `<leader>db`  | DAP: toggle breakpoint                              |
| `F10` / `<leader>do` | DAP: step over                                      |
| `F11` / `<leader>di` | DAP: step into                                      |
| `F12` / `<leader>dO` | DAP: step out                                       |
| `<leader>du`         | DAP: toggle UI                                      |
| `<leader>dx`         | DAP: terminate                                      |

## Applications

Installed via Home Manager (`home/system/packages.nix` and `home/programs/`):

| Category           | Apps                                                                                 |
| ------------------ | ------------------------------------------------------------------------------------ |
| **Browser**        | Brave, Chromium (+ Bitwarden extension), Bitwarden desktop                           |
| **Communication**  | Discord (OpenASAR), Spotify (adblock overlay)                                        |
| **Media**          | VLC, Gwenview, OBS Studio (PipeWire audio capture, VAAPI, NVENC/xcb fixes on NVIDIA) |
| **Files / notes**  | Dolphin, Obsidian                                                                    |
| **Network**        | Proton VPN                                                                           |
| **AI**             | Cursor, Claude Code                                                                  |
| **Dev / CLI**      | Neovim, VS Code, Postman, Docker Compose, virt-manager, fastfetch, btop, ripgrep, jq |
| **Hyprland tools** | hyprshot, hyprpicker, wtype, cliphist                                                |
| **System**         | pavucontrol, lxappearance                                                            |

Default MIME handlers: Brave (web/PDF), Gwenview (images), VLC (video).

## Theme and fonts

Dark Material-inspired setup (`home/system/theme.nix`):

| Element          | Value                                     |
| ---------------- | ----------------------------------------- |
| GTK theme        | Adwaita (adw-gtk3), dark                  |
| Qt theme         | qt5ct (`dots/qt5ct`), Darkly, Breeze      |
| Icons            | Papirus-Dark                              |
| Cursor           | Bibata-Modern-Ice, 24px                   |
| Sans font        | Rubik                                     |
| Monospace        | JetBrains Mono Nerd Font                  |
| Emoji            | Twitter Color Emoji                       |
| Quickshell fonts | Gabarito, Space Grotesk, Material Symbols |
| Terminal palette | Custom warm dark (Kitty)                  |

Wallpaper is `dots/quickshell/wallpaper.jpg`, referenced from Quickshell config as `~/.config/quickshell/wallpaper.jpg`.

## Development setup

| Tool        | Config                                                                                  |
| ----------- | --------------------------------------------------------------------------------------- |
| **Git**     | Name/email from host `variables.nix`, default branch `master`                           |
| **Neovim**  | NvChad, LSPs/formatters from nixpkgs, gdb DAP (see [Neovim](#neovim))                   |
| **direnv**  | Enabled with nix-direnv integration (zsh, VS Code)                                      |
| **VS Code** | Nix IDE, Python, Vue/Volar, Tailwind, ESLint, Prettier, Docker, LaTeX, WakaTime, direnv |
| **Docker**  | Enabled on workstation; user in `docker` group                                          |
| **libvirt** | KVM/QEMU with swtpm, SPICE USB redirection, `default` NAT network autostarted           |
| **nix-ld**  | Runs unpatched dynamic binaries                                                         |

VS Code: format on save, ESLint fix on save, Material Icon Theme.

virt-manager connects to `qemu:///system` automatically (dconf setting in `home/programs/virt-manager.nix`). The firewall trusts `virbr0`, so guests on the default NAT network reach host services.

## NixOS services

Shared modules in `nixos/`:

- **Boot**: GRUB (EFI, os-prober, 5 generations) + Plymouth, quiet kernel log, `mem_sleep_default=deep`
- **Audio**: PipeWire + WirePlumber, low-latency profile (48 kHz, 1024 quantum), NoiseTorch
- **Networking**: NetworkManager, Cloudflare (`1.1.1.1`) + Quad9 DNS, port 3000 open
- **Bluetooth**, **GVFS**, **udisks2**, Android tools (MTP/adb)
- **nix**: flakes, weekly GC (7d retention), unfree packages allowed
- **SDDM**: SilentSDDM catppuccin-latte theme, custom dark overrides, Wayland
- **Hyprland**: from the `hyprland` flake input, UWSM session, XWayland
- **Performance** (`nixos/performance.nix`): systemd-oomd on user slices, ananicy-cpp with CachyOS rules (realtime cgroup workaround disabled, otherwise Hyprland's children leave the logind session and polkit asks for admin auth on poweroff), idle-priority nix daemon, 256 MB journal cap. Laptop only: zram sized to RAM (zstd) with zram-tuned sysctls, MGLRU `min_ttl_ms`, sched_ext `scx_bpfland`, TLP schedutil + boost on battery, `max-jobs = 2`, `noatime` root
- **Workstation only**: Docker, libvirt/virt-manager, OpenSSH, weekly Claude Code auto-update (see below), `gpiolib_acpi.ignore_wake` for the chipset WAKE# pin that resumed S3 instantly

## Distributed builds

The laptop offloads heavy builds (e.g. Quickshell/Qt) to the workstation over SSH. See [`nixos/distributed-build.nix`](nixos/distributed-build.nix).

Requirements:

1. Workstation reachable at `192.168.0.60` (SSH host alias `workstation-builder`).
2. Root's `/root/.ssh/id_ed25519` on the laptop; public key in `nei@workstation:~/.ssh/authorized_keys`.
3. Workstation user `nei` in `nix.settings.trusted-users`.

If the workstation is offline, Nix falls back to local builds after a 5s connect timeout.

## Claude Code auto-update

Claude Code comes from the `claude-code` flake input ([claude-code-nix](https://github.com/sadjow/claude-code-nix)) because nixpkgs lags weeks behind upstream. On the workstation, [`nixos/claude-code-update.nix`](nixos/claude-code-update.nix) keeps it current with a weekly systemd timer that:

1. Runs `nix flake update claude-code` in `~/dotfiles` as the user (skipped if `flake.lock` has uncommitted changes).
2. Commits `flake.lock` with a `chore(claude-code): <old> -> <new>` message when the version changed.
3. Switches the system from the committed branch tip (`git+file://`), so unfinished edits in the checkout never get activated, then sends a desktop notification.

The timer is `Persistent`, so a run missed while the machine was off happens at the next boot. The commit is local; push it along with your own work.

```bash
systemctl list-timers claude-code-update   # next run
sudo systemctl start claude-code-update    # update now
journalctl -u claude-code-update           # log
```

## Flake inputs

| Input             | Purpose                                                  |
| ----------------- | -------------------------------------------------------- |
| `nixpkgs`         | nixos-unstable                                           |
| `home-manager`    | User environment                                         |
| `hyprland`        | Compositor (pinned from hyprwm)                          |
| `quickshell`      | Shell UI (tracks master, ≥ v0.3.1 for Lua dispatch)      |
| `silentSDDM`      | Login theme                                              |
| `code-cursor-nix` | Cursor editor                                            |
| `claude-code`     | Claude Code CLI (upstream releases, nixpkgs lags behind) |
| `nixos-hardware`  | Hardware modules (AMD CPU, laptop SSD)                   |

## Credits

- [end-4](https://github.com/end-4) for the Quickshell / dots-hyprland base
- [uiriansan](https://github.com/uiriansan) for SilentSDDM
- [sioodmy](https://github.com/sioodmy) for Nix configuration patterns
