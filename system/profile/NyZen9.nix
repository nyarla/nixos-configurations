{ pkgs, lib, ... }:
{
  imports = [
    ../config/audio/pipewire.nix
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
    ../config/hardware/firmware.nix
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
    ../config/linux/waydroid.nix
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
    ../config/security/ulimit.nix
    ../config/security/yubikey.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/droidcam.nix
    ../config/video/intel-with-nvidia.nix
    ../config/vmm/kvm.nix
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
      device = "/dev/disk/by-uuid/2b254558-0847-48f0-93c6-31a26d588d01";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };

    data = {
      device = "/dev/disk/by-uuid/062ba5c1-dd2f-4568-8cc1-c4b413976ce3";
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

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/c5fdfe0f-7cbb-4354-9bb1-6c3132c4fa6d";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.kernelModules = [
    "k10temp"
    "nct6775"
  ];
  boot.kernelParams = [
    "amd_pstate=active"
    # KVM
    # "amd_iommu=force_enable"
    # "vfio-pci.ids=1022:149c"
    #"efifb:off"
  ];
  boot.blacklistedKernelModules = [ "acpi-cpufreq" ];

  # Hardware
  # --------

  # clock
  time.hardwareClockInLocalTime = true; # for dualboot windows

  # network

  ## avahi
  services.avahi.allowInterfaces = [ "wlan0" ];

  ## tcp optimize
  networking.interfaces."wlan0".mtu = 1472;

  # fan control
  hardware.fancontrol = {
    enable = true;
    config = ''
      # scan tempture interval
      INTERVAL=10

      # hwmon2 = slot to Lexar NM790 4TB
      # hwmon4 = slot to CPU
      DEVPATH=hwmon2=devices/pci0000:00/0000:00:01.1/0000:01:00.0/nvme/nvme0 hwmon4=devices/platform/nct6775.656
      DEVNAME=hwmon2=nvme hwmon4=nct6798

      # hwmon4/temp2_input = CPU temperture
      # hwmon2/temp1_input = NVME SSD (Lexar NM790 4TB)
      FCTEMPS=hwmon4/pwm2=hwmon4/temp2_input hwmon4/pwm1=hwmon2/temp1_input

      # hwmon4/fan2 = CPU fan
      # hwmon4/fan7 = Exhaust fan (back)
      # hwmon4/fan1 = Intake fan (front)
      FCFANS=hwmon4/pwm2=hwmon4/fan7_input+hwmon4/fan2_input hwmon4/pwm1=hwmon4/fan1_input

      # Temperture limit
      # CPU: 20 <= temperature <= 70
      # NVMe: 30 <= temperature <= 50
      MINTEMP=hwmon4/pwm2=20 hwmon4/pwm1=30
      MAXTEMP=hwmon4/pwm2=70 hwmon4/pwm1=50

      # Start spin at nearly 1000rpm
      MINSTART=hwmon4/pwm2=100 hwmon4/pwm1=100

      # CPU fan stopped at pwm2 == 20
      # Case can stopped at pwm2 == 60
      MINSTOP=hwmon4/pwm2=12 hwmon4/pwm1=60
    '';
  };

  # Filesystem with Impermanence structure
  # --------------------------------------

  # mount
  fileSystems =
    let
      device = "/dev/disk/by-uuid/6fe94981-cc0a-4f8d-b853-4889781b3220";

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
          "noexec"
          "size=16G"
          "mode=755"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/BA2E-6B22";
        fsType = "vfat";
        options = [
          "umask=0077"
        ];
      };

      "/nix" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsOptions ++ [
          "subvol=/nix"
          "noatime"
        ];
        neededForBoot = true;
      };

      "/data" = {
        device = "/dev/disk/by-uuid/dd5610a1-a7f0-43cc-bbe5-24956b135b48";
        fsType = "btrfs";
        options = btrfsOptions;
        neededForBoot = false;
      };

      # fore data storage
      "/home/nyarla/Calibre" = {
        device = "/data/Calibre";
        options = [
          "bind"
          "x-gvfs-hide"
        ];
        neededForBoot = false;
      };
      "/home/nyarla/Music" = {
        device = "/data/Music";
        options = [
          "bind"
          "x-gvfs-hide"
        ];
        neededForBoot = false;
      };

      "/home/nyarla/Sources" = {
        device = "/data/Sources";
        options = [
          "bind"
          "x-gvfs-hide"
        ];
        neededForBoot = false;
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

      # for vm
      "var/lib/libvirt/images"

      # for accounts
      "home/nyarla"
    ])
    // (subvolsEx [
      # for boot
      "var/lib/docker"

      # for accounts
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
        dest = "/data/Calibre";
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
        dest = "/data/Music";
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
        name = "Sources";
        dest = "/data/Sources";
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

  # mount (as systemd service)
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
          test -e /backup/DAW     || mkdir -p /backup/DAW

          device=0c2fc422-2013-46eb-bc52-e6a4f6f145cb
          if test -e /dev/disk/by-uuid/$device && test -e /boot/keys/$device; then
            cryptsetup luksOpen /dev/disk/by-uuid/$device src --key-file /boot/keys/$device;
            if test $? = 0 && test -e /dev/mapper/src ; then
              mount -t btrfs -o compress=zstd,ssd,space_cache=v2,x-gvfs-hide /dev/mapper/src /media/data
              mount -o bind /media/data/DAW /backup/DAW
            fi
          fi
        ''
      );
      ExecStop = toString (
        pkgs.writeShellScript "unmount" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          test ! -e /backup/DAW       || umount /backup/DAW
          test ! -e /media/data       || umount /media/data
          test ! -e /dev/mapper/src  || ctryptsetup luksClose /dev/mapper/src
        ''
      );
    };
    wantedBy = [ "local-fs.target" ];
  };

  # btrfs settings
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

    "/data/Calibre"
    "/data/Music"
    "/data/Sources"
  ];

  # impermanence
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
          "Development"
          "Documents"
          "Downloads"
          "Pictures"
          "Programming"
          "Reports"
          "Sync"

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
          ".config/Yubico"
          ".config/act"
          ".config/blogsync"
          ".config/calibre"
          ".config/dconf"
          ".config/deadbeef"
          ".config/easytag"
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
          ".config/remmina"
          ".config/simple-scan"
          ".config/syncthing"
          ".config/tmux"
          ".config/whipper"
          ".config/xfce4"

          # .local
          ".local/share/TelegramDesktop"
          ".local/share/Trash"
          ".local/share/applications"
          ".local/share/com.poppingmoon.aria"
          ".local/share/fcitx5"
          ".local/share/fonts"
          ".local/share/libcskk"
          ".local/share/mime"
          ".local/share/npm"
          ".local/share/nvim"
          ".local/share/perl"
          ".local/share/pixelorama"
          ".local/share/remmina"
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
        ".npmrc"
      ];
    };
  };

  # snapshot
  services.snapper.configs =
    let
      snapshot = path: {
        SUBVOLUME = "${path}";
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
      nixos = "/persist/etc/nixos";
      varlib = "/persist/var/lib";
      usrshare = "/persist/usr/share";
      nyarla = "/persist/home/nyarla";
      apps = "/persist/home/nyarla/Applications";
      program = "/persist/home/nyarla/Programming";

      calibre = "/data/Calibre";
      music = "/data/Music";
      sources = "/data/Sources";
    };

  # Services
  # --------

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

  # Others
  # ------
  nixpkgs.config.permittedInsecurePackages = [ ];
  system.stateVersion = "24.11";
  environment.systemPackages = with pkgs; [ wpa_supplicant ];
}
