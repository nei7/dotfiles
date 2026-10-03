{
  config,
  lib,
  pkgs,
  ...
}:

# Desktop responsiveness tuning. Everything memory/CPU-budget related is
# laptop-only (8 GB MateBook); the rest is harmless on the workstation too.
let
  isLaptop = config.var.isLaptop or false;
in
{
  # ---------------------------------------------------------------------------
  # Memory (laptop)
  # ---------------------------------------------------------------------------

  # zram itself is enabled in power.nix. Size it to the full RAM: zstd packs
  # desktop pages ~3:1, so worst case this costs ~2.5 GB while providing ~7 GB
  # of fast swap. The on-disk swap partition stays as overflow (priority -2).
  zramSwap = lib.mkIf isLaptop {
    memoryPercent = 100;
    algorithm = "zstd";
  };

  boot.kernel.sysctl = lib.mkIf isLaptop {
    # zram guidance (kernel docs / Pop!_OS): prefer swapping cold anonymous
    # pages to compressed RAM over dropping page cache; no swap readahead.
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # Keep dentry/inode caches around longer.
    "vm.vfs_cache_pressure" = 50;
    # The SN530 is a DRAM-less NVMe: cap dirty pages so a large write (nix
    # store, downloads) cannot stall the desktop on writeback.
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
  };

  # MGLRU thrashing protection: under pressure keep pages touched within the
  # last second resident instead of evicting and re-faulting the working set.
  systemd.tmpfiles.rules = lib.optionals isLaptop [
    "w! /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 1000"
  ];

  # systemd-oomd is enabled by default but monitors no cgroups. Watch the user
  # slices so a runaway browser tab is killed before the session swaps to death.
  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
    settings.OOM.DefaultMemoryPressureDurationSec = "20s";
  };

  # ---------------------------------------------------------------------------
  # CPU scheduling
  # ---------------------------------------------------------------------------

  # sched_ext (kernel 6.18 has CONFIG_SCHED_CLASS_EXT): bpfland prioritises
  # interactive tasks (compositor, shell, input) over background CPU hogs.
  # If the userspace scheduler dies the kernel falls back to EEVDF.
  services.scx = lib.mkIf isLaptop {
    enable = true;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_bpfland";
  };

  # Auto-nice: browsers, compilers and nix builds get lower CPU/IO priority
  # than the compositor and shell (CachyOS rule set).
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Local nix builds (fallback when the workstation builder is offline) must
  # never make the desktop stutter or OOM the 8 GB box.
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings.max-jobs = lib.mkIf isLaptop 2;
  };

  # TLP: the MateBook BIOS exposes no CPPC (_CPC missing), so amd-pstate is
  # unavailable and acpi-cpufreq + schedutil is the best option. Keep boost on
  # battery so the UI stays snappy; savings come from idle states, not caps.
  services.tlp.settings = lib.mkIf isLaptop {
    CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 1;
    # Wi-Fi power save causes latency spikes for ~0.3 W of savings.
    WIFI_PWR_ON_BAT = "off";
  };

  # ---------------------------------------------------------------------------
  # Misc
  # ---------------------------------------------------------------------------

  # Journal was at 528 MB on disk; cap it.
  services.journald.extraConfig = "SystemMaxUse=256M";
}
