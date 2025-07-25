{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../config/audio/pipewire.nix
    ../config/audio/daw.nix
    ../config/cpu/amd.nix
    ../config/datetime/jp.nix
    ../config/desktop/files.nix
    ../config/desktop/wayland.nix
    ../config/desktop/xdg.nix
    ../config/desktop/xorg.nix
    ../config/gadgets/android.nix
    ../config/graphic/fonts.nix
    ../config/graphic/lodpi.nix
    ../config/hardware/firmware.nix
    ../config/hardware/weylus.nix
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
    ../config/linux/optimize.nix
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
    ../config/video/intel-with-amd.nix
    ../config/vmm/kvm.nix
    ../config/wireless/AX200.nix
    ../config/wireless/bluetooth.nix
    ../config/wireless/jp.nix

    ../config/services/nyzen9.nix
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

    windows = {
      device = "/dev/disk/by-uuid/c8810d52-8e8b-4dd9-a09a-4f1c21e56e54";
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

  ## for nvidia kernel modules
  systemd.services.amdgpu-kernel-modules = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.kmod
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = toString (
        pkgs.writeShellScript "load-nvidia-kmod.sh" ''
          set -euo pipefail
          modprobe amdgpu || exit 1
        ''
      );
      ExecStop = toString (
        pkgs.writeShellScript "unload-nvidia-kmod.sh" ''
          set -euo pipefail
          modprobe -r amdgpu || exit 1
        ''
      );
    };
  };

  # fan control
  systemd.services.fan2go =
    let
      config = pkgs.writeText "fan2go.yaml" (
        let
          fan = id: curve: index: {
            inherit id;
            inherit curve;
            hwmon = {
              platform = "nct6798";
              rpmChannel = index;
              pwmChannel = index;
            };
          };

          sensor = id: platform: index: {
            inherit id;
            hwmon = {
              inherit platform;
              inherit index;
            };
          };

          curve = id: sensor: steps: {
            inherit id;
            linear = {
              inherit sensor;
              inherit steps;
            };
          };
        in
        builtins.toJSON {
          dbPath = "/var/lib/fan2go/fan.db";

          fans = [
            (fan "cpu" "cpu" 2)
            (fan "case" "case" 1)
            (fan "back" "cpu" 7)
          ];
          sensors = [
            (sensor "cpu" "k10temp" 1)
            (sensor "nvme-pci-0100" "nvme-pci-0100" 1)
            (sensor "nvme-pci-0800" "nvme-pci-0800" 1)
          ];
          curves = [
            (curve "cpu" "cpu" {
              "30" = 15;
              "70" = 255;
            })
            (curve "nvme-pci-0100" "nvme-pci-0100" {
              "30" = 100;
              "65" = 255;
            })
            (curve "nvme-pci-0800" "nvme-pci-0800" {
              "30" = 100;
              "65" = 255;
            })
            {
              id = "case";
              function = {
                type = "average";
                curves = [
                  "cpu"
                  "nvme-pci-0100"
                  "nvme-pci-0800"
                ];
              };
            }
          ];
        }
      );
    in
    {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "lm_sensors.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.fan2go}/bin/fan2go -c ${config}";
        ExecStartPre = "${pkgs.fan2go}/bin/fan2go -c ${config} config validate";
        Restart = "always";
      };
    };
  powerManagement.resumeCommands = ''
    systemctl restart fan2go.service
  '';

  # Filesystem with Impermanence structure
  # --------------------------------------

  # usb automount
  systemd.services.automount-encrypted-usb-device = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Automount service for encrypted usb storage";
    path = with pkgs; [
      coreutils
      cryptsetup
      "/run/wrappers/bin"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = toString (
        pkgs.writeShellScript "mount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          mount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ ! -e /dev/disk/by-uuid/$deviceId ]]; then
              echo "/dev/disk/by-uuid/$deviceId is not found."
              exit 0
            fi

            if [[ ! -e /boot/keys/$deviceId ]]; then
              echo "/boot/keys/$deviceId is not found."
              exit 0
            fi

            if [[ ! -e /persist/data/$deviceId ]]; then
              mkdir -p /persist/data/$deviceId
            fi

            if [[ ! -e /dev/mapper/dev-disk-by-uuid-$deviceId ]]; then
              cryptsetup luksOpen \
                --key-file /boot/keys/$deviceId \
                /dev/disk/by-uuid/$deviceId dev-disk-by-uuid-$deviceId
            fi

            if [[ ! -e /persist/data/$deviceId/.keep ]]; then
              mount -t btrfs -o compress=zstd,ssd,space_cache=v2,x-gvfs-hide,noexec,nosuid,nodev \
                /dev/mapper/dev-disk-by-uuid-$deviceId \
                /persist/data/$deviceId
            fi

            return 0
          }

          backup-if-exists() {
            local deviceId
            deviceId=$1

            local dirName
            dirName=$2

            if [[ ! -e /persist/data/$deviceId/$dirName ]]; then
              echo "/persist/data/$deviceId/$dirName is not found."
              exit 0
            fi

            if [[ ! -e /backup/$dirName ]]; then
              mkdir -p /backup/$dirName
            fi

            mount -o bind /persist/data/$deviceId/$dirName /backup/$dirName
            return $?
          }

          mount-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Calibre
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Music
        ''
      );

      ExecStop = toString (
        pkgs.writeShellScript "unmount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          unbind-if-exists() {
            local dirName
            dirName=$1

            if [[ -e /backup/$dirName ]]; then
              umount /backup/$dirName
            fi

            return 0
          }

          unmount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ -e /persist/data/$deviceId ]]; then
              umount /persist/data/$deviceId || true
            fi

            if [[ -e /dev/mapper/dev-disk-by-uuid-$deviceId ]]; then
              cryptsetup luksClose /dev/mapper/dev-disk-by-uuid-$deviceId
            fi

            return 0
          }

          unbind-if-exists Calibre
          unbind-if-exists Music

          unmount-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7

          exit 0
        ''
      );
    };
  };

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

      subvolRW = neededForBoot: path: {
        "/persist/${path}" = {
          inherit device;
          fsType = "btrfs";
          options = btrfsRWOnly ++ [ "subvol=/persist/${path}" ];
          inherit neededForBoot;
        };
      };

      subvolEx = neededForBoot: path: {
        "/persist/${path}" = {
          inherit device;
          fsType = "btrfs";
          options = btrfsOptions ++ [ "subvol=/persist/${path}" ];
          inherit neededForBoot;
        };
      };

      subvolsEx =
        required: paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths (subvolEx required));
      subvolsRW =
        required: paths: lib.attrsets.mergeAttrsList (lib.lists.forEach paths (subvolRW required));

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

      "/vm/main" = {
        inherit device;
        fsType = "btrfs";
        options = btrfsRWOnly ++ [
          "subvol=/persist/vm/main"
          "nodatacow"
        ];
        neededForBoot = false;
      };

      "/vm/special" = {
        device = "/dev/disk/by-uuid/653bc854-edfe-4c73-a535-07b38da44f19";
        fsType = "btrfs";
        options = btrfsRWOnly ++ [
          "nodatacow"
        ];
        neededForBoot = false;
      };
    }
    // (subvolsRW true [
      # for boot
      "etc"
      "etc/nixos"
      "var/db"
      "var/lib"
      "var/log"

      # for vm
      "var/lib/libvirt/images"

      # for accounts
      "home/nyarla"
    ])
    // (subvolsEx false [
      "var/lib/flatpak"
    ])
    // (subvolsEx false [
      # for accounts
      "home/nyarla/.cache/nvim"
      "home/nyarla/.config/audiogridder"
      "home/nyarla/.fly"
      "home/nyarla/.lmstudio"
      "home/nyarla/.local/share/containers"
      "home/nyarla/.local/share/nvim"
      "home/nyarla/.local/share/waydroid"
      "home/nyarla/.mozilla"
      "home/nyarla/.triton"
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
        name = "Development";
        dest = "/persist/home/nyarla/Development";
      }
      {
        name = "Documents";
        dest = "/persist/home/nyarla/Documents";
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
        dest = "/persist/home/nyarla/Sources";
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

  # btrfs settings
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/nix"

    "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Calibre"
    "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Music"

    "/persist/etc"
    "/persist/etc/nixos"

    "/persist/home/nyarla/.cache/nvim"
    "/persist/home/nyarla/.config/audiogridder"
    "/persist/home/nyarla/.fly"
    "/persist/home/nyarla/.lmstudio"
    "/persist/home/nyarla/.local/share/containers"
    "/persist/home/nyarla/.local/share/nvim"
    "/persist/home/nyarla/.local/share/waydroid"
    "/persist/home/nyarla/.mozilla"
    "/persist/home/nyarla/.wrangler"
    "/persist/home/nyarla/Applications"
    "/persist/home/nyarla/Programming"

    "/persist/var/db"
    "/persist/var/lib"
    "/persist/var/log"

    "/vm/main"
    "/vm/main/DAW/images"

    "/vm/special"
    "/vm/special/images"
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
          "Sources"
          "Sync"

          # cache
          ".cache/act"
          ".cache/actcache"
          ".cache/nix"
          ".cache/nvim"
          ".cache/wine"
          ".cache/winetricks"

          # .config
          ".config/Bitwarden"
          ".config/ChowdhuryDSP"
          ".config/FamiStudio"
          ".config/GIMP"
          ".config/Helio"
          ".config/Jean Pierre Cimalando"
          ".config/Kvantum"
          ".config/LibreArp"
          ".config/MuseScore"
          ".config/MusicBrainz"
          ".config/OpenUtau"
          ".config/Sononym"
          ".config/Thunar"
          ".config/Yubico"
          ".config/act"
          ".config/aseprite"
          ".config/audiogridder"
          ".config/blender"
          ".config/blogsync"
          ".config/calibre"
          ".config/dconf"
          ".config/deadbeef"
          ".config/easytag"
          ".config/falkTX"
          ".config/fcitx5"
          ".config/google-chrome"
          ".config/gtk-2.0"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/gyazo"
          ".config/hypr"
          ".config/inkscape"
          ".config/llm"
          ".config/lmstudio"
          ".config/lxqt"
          ".config/nvim"
          ".config/pulse"
          ".config/rclone"
          ".config/remmina"
          ".config/simple-scan"
          ".config/syncthing"
          ".config/tmux"
          ".config/vlc"
          ".config/voicevox"
          ".config/whipper"
          ".config/xfce4"

          # .local
          ".local/share/DigitalSuburban"
          ".local/share/MuseScore"
          ".local/share/TelegramDesktop"
          ".local/share/Trash"
          ".local/share/applications"
          ".local/share/containers"
          ".local/share/fcitx5"
          ".local/share/fonts"
          ".local/share/krita"
          ".local/share/libcskk"
          ".local/share/mime"
          ".local/share/nvim"
          ".local/share/odin2"
          ".local/share/pixelorama"
          ".local/share/remmina"
          ".local/share/vlc"
          ".local/share/waydroid"
          ".local/share/zrythm"

          # state
          ".local/state/wireplumber"

          # application
          ".BitwigStudio"
          ".android"
          ".helm"
          ".lmstudio"
          ".mozilla"
          ".pki"
          ".thunderbird"
          ".vst"
          ".vst3"

          # credentials
          (secure ".gnupg")
          (secure ".local/share/keyrings")
          (secure ".ssh")
          (secure ".wrangler")
        ];
      files = [
        # development
        ".npmrc"
        ".zynaddsubfx-bank-cache.xml"

        # creative
        ".config/kritadisplayrc"
        ".config/kritarc"
        ".config/snn.conf"
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
      data-music = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Music";
      data-calibre = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Music";

      etc-nixos = "/persist/etc/nixos";

      home-nyarla = "/persist/home/nyarla";
      home-nyarla-applications = "/persist/home/nyarla/Applications";
      home-nyarla-programming = "/persist/home/nyarla/Programming";

      var-lib = "/persist/var/lib";
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
      "^/vm"
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
