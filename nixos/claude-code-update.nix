{
  config,
  pkgs,
  ...
}:

# Weekly Claude Code update. Claude Code releases several times a week and
# nixpkgs lags behind, so the package comes from the claude-code-nix flake
# input (home/system/packages.nix); this timer keeps that input current:
# bump it in the dotfiles checkout, commit flake.lock as the user, switch.
#
#   systemctl list-timers claude-code-update   # next run
#   sudo systemctl start claude-code-update    # run now
#   journalctl -u claude-code-update           # what happened
let
  user = config.var.username;
  home = "/home/${user}";
  repo = "${home}/dotfiles";
  input = "claude-code";
  system = pkgs.stdenv.hostPlatform.system;
in
{
  systemd.services.claude-code-update = {
    description = "Bump the ${input} flake input and switch the system";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    # The nixos-rebuild inside must not restart or stop this very unit.
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    serviceConfig.Type = "oneshot";
    environment.HOME = "/root";
    path = [
      pkgs.gitMinimal
      pkgs.jq
      pkgs.util-linux
      pkgs.coreutils
      pkgs.libnotify
      config.nix.package
      config.system.build.nixos-rebuild
    ];

    script = ''
      set -euo pipefail

      # Repo operations run as the owner: the commit carries their git identity
      # and no root-owned files land in the checkout. runuser resets PATH and
      # HOME, so hand both over explicitly.
      as_user() {
        runuser -u ${user} -- ${pkgs.coreutils}/bin/env HOME=${home} PATH="$PATH" "$@"
      }

      # Version of the package the lock currently points at.
      input_version() {
        local url
        url=$(jq -r '.nodes["${input}"].locked | "github:\(.owner)/\(.repo)/\(.rev)"' ${repo}/flake.lock)
        as_user nix eval --raw "$url#packages.${system}.default.version"
      }

      cd ${repo}

      if ! as_user git diff --quiet HEAD -- flake.lock; then
        echo "flake.lock has uncommitted changes, skipping"
        exit 0
      fi

      old=$(input_version)
      as_user nix flake update ${input}

      if as_user git diff --quiet HEAD -- flake.lock; then
        echo "${input} already up to date ($old)"
        exit 0
      fi

      new=$(input_version)
      as_user git commit -q -m "chore(${input}): $old -> $new" -- flake.lock
      echo "committed ${input} $old -> $new"

      # Build the committed branch tip, not the working tree, so half-done
      # edits in the checkout never reach the running system.
      branch=$(as_user git symbolic-ref --short HEAD)
      nixos-rebuild switch --flake "git+file://${repo}?ref=$branch#${config.var.hostname}"

      as_user ${pkgs.coreutils}/bin/env \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ${user})/bus \
        notify-send "Claude Code updated" "$old -> $new" || true
    '';
  };

  systemd.timers.claude-code-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      # The workstation is often suspended or off at Monday 00:00: run the
      # missed job at the next boot instead of waiting another week.
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
}
