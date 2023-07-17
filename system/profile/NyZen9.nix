{ pkgs, lib, ... }: {
  imports = [
    ../config/audio/pulseaudio.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/desktop/files.nix
    ../config/desktop/xorg.nix
    ../config/gadgets/android.nix
    ../config/graphic/fonts.nix
    ../config/graphic/lodpi.nix
    ../config/graphic/xorg.nix
    ../config/i18n/en.nix
    ../config/i18n/fcitx5.nix
    ../config/i18n/locales.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/dbus.nix
    ../config/linux/docker.nix
    ../config/linux/filesystem.nix
    ../config/linux/hardware.nix
    ../config/linux/kvm.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/process.nix
    ../config/linux/waydroid.nix
    ../config/linux/wine.nix
    ../config/networking/agent.nix
    #../config/networking/avahi.nix
    ../config/networking/network-manager.nix
    #../config/networking/openssh.nix
    ../config/networking/printer.nix
    ../config/networking/tailscale.nix
    ../config/networking/tcp-bbr.nix
    ../config/nixos/gsettings.nix
    ../config/nixos/nix-ld.nix
    ../config/nixos/nixpkgs.nix
    ../config/security/1password.nix
    ../config/security/clamav.nix
    ../config/security/firewall-home.nix
    ../config/security/gnupg.nix
    ../config/security/yubikey.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/droidcam.nix
    ../config/video/nvidia.nix
    ../config/webapp/NyZen9.nix
    ../config/wireless/AX200.nix
    ../config/wireless/bluetooth.nix
    ../config/wireless/jp.nix
  ];

  # Machine specific configurations
  # ===============================

  # Boot
  # ----

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # initrd
  boot.initrd.luks.devices = {
    nixos = {
      device = "/dev/disk/by-uuid/71779cc6-0484-4dac-9cb9-6f10f10e6a2d";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # tmpfs
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" "kvm" "kvm-amd" ];
  boot.kernelParams = [
    # CPU
    "noibrs"
    "pti=off"
    "kpti=off"

    # KVM
    "vfio-pci.ids=1022:149c,10de:1e89,10de:10f8,10de:1ad8,10de:1ad9"
    "efifb:off"
  ];

  # filesystem
  fileSystems = let
    device = "/dev/disk/by-uuid/34da11a3-1b2e-49e4-a318-33404cd9e4ea";

    btrfsOptions = [ "compress=zstd" "ssd" "space_cache=v2" ];
    btrfsNoExec = [ "noexec" "nosuid" "nodev" ];
    btrfsRWOnly = btrfsOptions ++ btrfsNoExec;

    subvolRW = path: {
      "/persist/${path}" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsRWOnly ++ [ "subvol=/persist/${path}" ];
        neededForBoot = true;
      };
    };

    subvolEx = path: {
      "/persist/${path}" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsOptions ++ [ "subvol=/persist/${path}" ];
        neededForBoot = true;
      };
    };

    backup = path: dest: {
      "/backup/${path}" = {
        device = dest;
        options = [ "bind" ];
      };
    };
  in {
    # for boot
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/709E-6BDD";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/34da11a3-1b2e-49e4-a318-33404cd9e4ea";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=/nix" "noatime" ];
      neededForBoot = true;
    };
  }
  # for boot
  // (subvolRW "etc") // (subvolRW "etc/nixos")

  // (subvolRW "var/db") // (subvolRW "var/lib") // (subvolEx "var/lib/docker")
  // (subvolRW "var/log")

  // (subvolRW "usr/share")

  # for account
  // (subvolRW "home/nyarla") // (subvolEx "home/nyarla/Applications")
  // (subvolEx "home/nyarla/Programming")
  // (subvolEx "home/nyarla/.local/share/npm")
  // (subvolEx "home/nyarla/.local/share/nvim")
  // (subvolEx "home/nyarla/.local/share/perl")
  // (subvolEx "home/nyarla/.local/share/vim-lsp-settings")
  // (subvolEx "home/nyarla/.local/share/waydroid")

  # for backup
  // (backup "Applications" "/persist/home/nyarla/Applications")
  // (backup "Archives" "/persist/home/nyarla/Archives")
  // (backup "Calibre" "/persist/home/nyarla/Calibre")
  // (backup "Development" "/persist/home/nyarla/Development")
  // (backup "Documents" "/persist/home/nyarla/Documents")
  // (backup "Music" "/persist/home/nyarla/Music")
  // (backup "NixOS" "/persist/etc/nixos")
  // (backup "Programming" "/persist/home/nyarla/Programming")

  ;

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/persist/nix"

    "/persist/etc"
    "/persist/etc/nixos"
    "/persist/etc/sane-libs"
    "/persist/etc/sane-config"

    "/persist/var/db"
    "/persist/var/lib"
    "/persist/var/lib/docker"
    "/persist/var/log"

    "/persist/home/nyarla"
    "/persist/home/nyarla/Applications"
    "/persist/home/nyarla/Programming"
    "/persist/home/nyarla/.local/share/npm"
    "/persist/home/nyarla/.local/share/nvim"
    "/persist/home/nyarla/.local/share/perl"
    "/persist/home/nyarla/.local/share/vim-lsp-settings"
    "/persist/home/nyarla/.local/share/waydroid"
  ];

  swapDevices = [ ];

  # Impermanence
  # ------------
  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/NetworkManager"
      "/etc/nixos"
      "/etc/ssh"
      "/etc/wpa_supplicant"

      "/var/db"
      "/var/lib"
      "/var/log"

      "/usr/share/waydroid-extra/images"
    ];
    files = [ "/etc/machine-id" ];

    users.nyarla = {
      directories = let
        secure = directory: {
          inherit directory;
          mode = "0700";
        };
      in [
        # data
        "Applications"
        "Archives"
        "Calibre"
        "Development"
        "Documents"
        "Downloads"
        "Music"
        "Programming"
        "Reports"
        "Sync"

        # cache
        ".cache/winetricks"

        # .config
        ".config/1Password"
        ".config/BraveSoftware"
        ".config/MusicBrainz"
        ".config/TabNine"
        ".config/Thunar"
        ".config/Yubico"
        ".config/calibre"
        ".config/dconf"
        ".config/fcitx5"
        ".config/gcloud"
        ".config/google-chrome"
        ".config/gtk-2.0"
        ".config/gtk-3.0"
        ".config/gtk-4.0"
        ".config/lxqt"
        ".config/nvim"
        ".config/pulse"
        ".config/rclone"
        ".config/simple-scan"
        ".config/syncthing"
        ".config/wezterm"
        ".config/whipper"
        ".config/xfce4"

        # .local
        ".local/share/TabNine"
        ".local/share/Trash"
        ".local/share/applications"
        ".local/share/fcitx5"
        ".local/share/fonts"
        ".local/share/mime"
        ".local/share/npm"
        ".local/share/nvim"
        ".local/share/perl"
        ".local/share/vim-lsp-settings"
        ".local/share/waydroid"

        # application
        ".1password"
        ".android"
        ".mozilla"
        ".pki"
        ".thunderbird"

        # credentials
        (secure ".aws")
        (secure ".fly")
        (secure ".gnupg")
        (secure ".gsutil")
        (secure ".local/share/keyrings")
        (secure ".ssh")
        (secure ".wrangler")
      ];
      files = [ ".config/mimeapps.list" ".gtkrc-2.0" ".npmrc" ".zsh_history" ];
    };
  };

  # Hardware
  # --------

  # cpu
  powerManagement.cpuFreqGovernor = "performance";
  boot.blacklistedKernelModules = [ "acpi-cpufreq" ];

  # firmware
  hardware.enableRedistributableFirmware = true;

  # Network
  # -------

  # samba
  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    securityType = "user";
    # package = pkgs.samba4Full;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nixos
      netbios name = nixos
      security = user
      use sendfile = yes
      hosts allow = 192.168.240.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      Music = {
        "path" = "/home/nyarla/Music";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "yes";
      };
    };
  };

  # Services
  # --------

  # snapper
  services.snapper.configs = let
    snapshot = path: {
      SUBVOLUME = "/persist/${path}";
      ALLOW_USERS = [ "nyarla" ];
      ALLOW_GROUP = [ "users" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMETINE_MIN_AGE = 1800;
      TIMELINE_LIMIT_HOURLY = 6;
      TIMELIME_DAILY = 7;
      TIMELINE_WEEKLY = 2;
      TIMELINE_MONTHLY = 1;
      TIMELINE_YEARLY = 1;
    };
  in {
    nixos = snapshot "etc/nixos";

    varlib = snapshot "var/lib";
    usrshare = snapshot "usr/share";

    nyarla = snapshot "home/nyarla";
    apps = snapshot "home/nyarla/Applications";
    program = snapshot "home/nyarla/Programming";
  };

  # systemd
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=90s
    DefaultTimeoutStopSec=90s
  '';

  # waydroid
  systemd.services.waydroid-container.environment = {
    XDG_DATA_HOME = "/persist/home/nyarla/.local/share";
  };

  # Xorg
  services.picom.backend = "glx";
  services.xserver.serverLayoutSection = ''
    Option "BlankTime"    "0"
    Option "StandbyTime"  "1"
    Option "SuspendTime"  "1"
    Option "OffTime"      "1"
  '';
  services.xserver.xrandrHeads = [{
    output = "HDMI-0";
    monitorConfig = ''
      Option "DPMS" "true"
    '';
  }];

  # clamav
  services.clamav.daemon.settings = {
    ExcludePath = [
      "^/backup"
      "^/dev"
      "^/home/nyarla/Reports"
      "^/nix"
      "^/persist/home/nyarla/Reports"
      "^/proc"
      "^/sys"
      ".snapshots/[0-9]+"
    ];
    MaxThreads = 30;
  };

  systemd.user.services.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "clamav-scan.sh" ''
        set -euo pipefail

        export PATH=${lib.makeBinPath (with pkgs; [ clamav ])}:$PATH

        clamdscan -l /home/nyarla/Reports/clamav.log -i -m --fdpass / || true

        exit 0
      '');
    };
  };

  systemd.user.timers.clamav-scan = {
    enable = true;
    description = "Full Virus Scan by ClamAV";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [ "electron-19.0.7" ];

  system.stateVersion = "23.05";

  environment.systemPackages = with pkgs; [ wpa_supplicant ];

}
