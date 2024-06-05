{ pkgs, lib, ... }:
{
  imports = [
    ../config/audio/daw.nix
    ../config/audio/pulseaudio.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/desktop/files.nix
    ../config/desktop/flatpak.nix
    ../config/desktop/wayland.nix
    ../config/desktop/xdg.nix
    ../config/desktop/xorg.nix
    ../config/gadgets/android.nix
    ../config/graphic/fonts.nix
    ../config/graphic/lodpi.nix
    ../config/i18n/en.nix
    ../config/i18n/fcitx5.nix
    ../config/i18n/locales.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/docker.nix
    ../config/linux/filesystem.nix
    ../config/linux/hardware.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/process.nix
    ../config/linux/virtualbox.nix
    ../config/linux/waydroid.nix
    ../config/linux/wine.nix
    ../config/networking/agent.nix
    ../config/networking/avahi.nix
    ../config/networking/network-manager.nix
    ../config/networking/printer.nix
    ../config/networking/tailscale.nix
    ../config/nixos/gsettings.nix
    ../config/nixos/nix-ld.nix
    ../config/security/clamav.nix
    ../config/security/firewall-home.nix
    ../config/security/gnupg.nix
    ../config/security/yubikey.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/droidcam.nix
    ../config/video/intel-with-nvidia.nix
    ../config/webapp/llm.nix
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

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  # tmpfs
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.kernelModules = [
    "k10temp"
    "nct6775"
    "amd-pstate"
  ];
  boot.kernelParams = [
    "amd_pstate=active"
    # KVM
    # "amd_iommu=force_enable"
    # "vfio-pci.ids=1022:149c"
    #"efifb:off"
  ];
  boot.blacklistedKernelModules = [ "acpi-cpufreq" ];

  fileSystems =
    let
      device = "/dev/disk/by-uuid/34da11a3-1b2e-49e4-a318-33404cd9e4ea";

      btrfsOptions = [
        "compress=zstd"
        "ssd"
        "space_cache=v2"
        "x-gvfs-hide"
      ];
      btrfsNoExec = [
        "noexec"
        "nosuid"
        "nodev"
      ];
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

      subvolsEx = paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths subvolEx);
      subvolsRW = paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths subvolRW);

      backup = path: dest: {
        "/backup/${path}" = {
          device = dest;
          options = [ "bind" ];
        };
      };

      backups =
        paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths ({ name, dest }: backup name dest));
    in
    {
      # for boot
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=16G"
          "mode=755"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/709E-6BDD";
        fsType = "vfat";
      };

      "/nix" = {
        device = "/dev/disk/by-uuid/34da11a3-1b2e-49e4-a318-33404cd9e4ea";
        fsType = "btrfs";
        options = btrfsOptions ++ [
          "subvol=/nix"
          "noatime"
        ];
        neededForBoot = true;
      };
    }
    // (subvolsRW [
      # for boot
      "etc"
      "etc/nixos"
      "usr/share"
      "var/db"
      "var/lib"
      "var/log"

      # for accounts
      "home/nyarla"
    ])
    // (subvolsEx [
      # for boot
      "var/lib/docker"

      # for accounts
      "home/nyarla/.config/audiogridder"
      "home/nyarla/.fly"
      "home/nyarla/.local/share/flatpak"
      "home/nyarla/.local/share/npm"
      "home/nyarla/.local/share/nvim"
      "home/nyarla/.local/share/perl"
      "home/nyarla/.local/share/waydroid"
      "home/nyarla/.mozilla"
      "home/nyarla/.var"
      "home/nyarla/.wrangler"
      "home/nyarla/Applications"
      "home/nyarla/Programming"
    ])
    // (backups [
      {
        name = "Applications";
        dest = "/persist/home/nyarla/Applications";
      }
      {
        name = "Archives";
        dest = "/persist/home/nyarla/Archives";
      }
      {
        name = "Calibre";
        dest = "/persist/home/nyarla/Calibre";
      }
      {
        name = "Development";
        dest = "/persist/home/nyarla/Development";
      }
      {
        name = "Documents";
        dest = "/persist/home/nyarla/Documents";
      }
      {
        name = "Music";
        dest = "/persist/home/nyarla/Music";
      }
      {
        name = "NixOS";
        dest = "/persist/etc/nixos";
      }
      {
        name = "Pictures";
        dest = "/persist/home/nyarla/Pictures";
      }
      {
        name = "Programming";
        dest = "/persist/home/nyarla/Programming";
      }
      {
        name = "Sync";
        dest = "/persist/home/nyarla/Sync/Backup";
      }
      {
        name = "Thunderbird";
        dest = "/persist/home/nyarla/.thunderbird";
      }
    ]);

  systemd.services.automount-encrypted-storages = {
    enable = true;
    description = "Automount Encrypted Storages";
    path = with pkgs; [
      coreutils
      cryptsetup
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = toString (
        pkgs.writeShellScript "mount" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          test -e /media/data     || mkdir -p /media/data
          test -e /media/src      || mkdir -p /media/src
          test -e /backup/DAW     || mkdir -p /backup/DAW
          test -e /backup/Sources || mkdir -p /backup/Sources

          device=0c2fc422-2013-46eb-bc52-e6a4f6f145cb
          if test -e /dev/disk/by-uuid/$device && test -e /boot/keys/$device; then
            cryptsetup luksOpen /dev/disk/by-uuid/$device data --key-file /boot/keys/$device;
            if test $? = 0 && test -e /dev/mapper/data ; then
              mount -t btrfs -o compress=zstd,ssd,space_cache=v2,x-gvfs-hide /dev/mapper/data /media/data
              mount -o bind /media/data/DAW /backup/DAW
            fi
          fi

          device=a3da35b5-35e8-45bb-a4b4-87fbc19ed459
          if test -e /dev/disk/by-uuid/$device && test -e /boot/keys/$device; then
            cryptsetup luksOpen /dev/disk/by-uuid/$device src --key-file /boot/keys/$device;
            if test $? = 0 && test -e /dev/mapper/src ; then
              mount -t btrfs -o compress=zstd,ssd,space_cache=v2,x-gvfs-hide /dev/mapper/src /media/src
              mount -o bind /media/src/Sources /backup/Sources
            fi
          fi
        ''
      );
      ExecStop = toString (
        pkgs.writeShellScript "unmount" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          test ! -e /backup/DAW       || umount /backup/DAW
          test ! -e /backup/Sources   || umount /backup/Sources
          test ! -e /media/data       || umount /media/data
          test ! -e /media/src        || umount /media/src

          test ! -e /dev/mapper/data  || ctryptsetup luksClose /dev/mapper/data
          test ! -e /dev/mapper/src   || ctryptsetup luksClose /dev/mapper/src
        ''
      );
    };
    wantedBy = [ "local-fs.target" ];
  };

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/nix"

    "/persist/etc"
    "/persist/etc/nixos"

    "/persist/var/db"
    "/persist/var/lib"
    "/persist/var/lib/docker"
    "/persist/var/log"

    "/persist/usr/share"

    "/persist/home/nyarla/.config/audiogridder"
    "/persist/home/nyarla/.fly"
    "/persist/home/nyarla/.local/share/flatpak"
    "/persist/home/nyarla/.local/share/npm"
    "/persist/home/nyarla/.local/share/nvim"
    "/persist/home/nyarla/.local/share/perl"
    "/persist/home/nyarla/.local/share/waydroid"
    "/persist/home/nyarla/.mozilla"
    "/persist/home/nyarla/.var"
    "/persist/home/nyarla/.wrangler"
    "/persist/home/nyarla/Applications"
    "/persist/home/nyarla/Programming"
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
      "/var/lib/docker"
    ];
    files = [ "/etc/machine-id" ];

    users.nyarla = {
      directories =
        let
          secure = directory: {
            inherit directory;
            mode = "0700";
          };
        in
        [
          # data
          "Applications"
          "Archives"
          "Calibre"
          "Development"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Programming"
          "Reports"
          "Sync"

          # music
          ".config/Helio"
          ".config/Ildaeil"
          ".config/Jean Pierre Cimalando"
          ".config/MuseScore"
          ".config/Sononym"
          ".config/audiogridder"
          ".config/falkTX"
          ".config/rncbc.org"
          ".config/yabridgectl"
          ".helm"
          ".local/share/DigitalSuburban"
          ".local/share/MuseScore"

          # cache
          ".cache/act"
          ".cache/actcache"
          ".cache/nix"
          ".cache/wine"
          ".cache/winetricks"

          # .config
          ".config/Bitwarden"
          ".config/GIMP"
          ".config/Kvantum"
          ".config/MusicBrainz"
          ".config/Thunar"
          ".config/VirtualBox"
          ".config/Yubico"
          ".config/act"
          ".config/calibre"
          ".config/dconf"
          ".config/fcitx5"
          ".config/gcloud"
          ".config/gh"
          ".config/google-chrome"
          ".config/gtk-2.0"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/gyazo"
          ".config/inkscape"
          ".config/nvim"
          ".config/pulse"
          ".config/rclone"
          ".config/simple-scan"
          ".config/syncthing"
          ".config/tmux"
          ".config/wezterm"
          ".config/whipper"
          ".config/xfce4"

          # .local
          ".local/share/TelegramDesktop"
          ".local/share/Trash"
          ".local/share/applications"
          ".local/share/fcitx5"
          ".local/share/fonts"
          ".local/share/libcskk"
          ".local/share/mime"
          ".local/share/npm"
          ".local/share/nvim"
          ".local/share/perl"
          ".local/share/pixelorama"
          ".local/share/waydroid"

          # application
          ".android"
          ".mozilla"
          ".pki"
          ".thunderbird"
          ".var"
          ".codeium"

          # credentials
          (secure ".fly")
          (secure ".gnupg")
          (secure ".gsutil")
          (secure ".local/share/keyrings")
          (secure ".ssh")
          (secure ".wrangler")
        ];
      files = [
        ".clasprc.json"
        ".config/mimeapps.list"
        ".config/snn.conf"
        ".npmrc"
      ];
    };
  };

  # Hardware
  # --------

  # firmware
  hardware.enableRedistributableFirmware = true;

  # clock
  time.hardwareClockInLocalTime = true; # for dualboot windows

  # Network
  # -------

  # avahi
  services.avahi.allowInterfaces = [ "wlan0" ];

  # tcp optimize
  networking.interfaces."wlan0".mtu = 1472;

  # Services
  # --------

  # snapper
  services.snapper.configs =
    let
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

      snapshots = paths: lib.attrsets.concatMapAttrs (n: v: { "${n}" = snapshot v; }) paths;
    in
    snapshots {
      nixos = "etc/nixos";
      varlib = "var/lib";
      usrshare = "usr/share";
      nyarla = "home/nyarla";
      apps = "home/nyarla/Applications";
      program = "home/nyarla/Programming";
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
      ExecStart = toString (
        pkgs.writeShellScript "clamav-scan.sh" ''
          set -euo pipefail

          export PATH=${lib.makeBinPath (with pkgs; [ clamav ])}:$PATH

          clamdscan -l /home/nyarla/Reports/clamav.log -i -m --fdpass / || true

          exit 0
        ''
      );
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

  # backup by restic
  systemd.services.backup = {
    enable = true;
    path = with pkgs; [
      restic-run
      rclone
    ];
    description = "Automatic backup by restic and rclone";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "backup.sh" ''
          set -euo pipefail
          export HOME=/home/nyarla

          if test -d /backup ; then
            cd /backup
            restic-backup .
          fi

          exit 0
        ''
      );
    };
  };

  systemd.timers.backup = {
    enable = true;
    description = "Automatic backup by restic and rclone";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [ ];

  system.stateVersion = "23.05";

  environment.systemPackages = with pkgs; [ wpa_supplicant ];
}
