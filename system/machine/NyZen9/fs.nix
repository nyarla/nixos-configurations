{ lib, ... }:
{
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

      subvol =
        {
          device,
          path,
          neededForBoot,
          options,
        }:
        {
          "${path}" = {
            inherit device;
            fsType = "btrfs";
            options = options ++ [ "subvol=${path}" ];
            inherit neededForBoot;
          };
        };

      persist =
        {
          device,
          neededForBoot,
          options,
          paths,
        }:
        lib.attrsets.mergeAttrsList (
          lib.lists.forEach paths (
            path:
            subvol {
              inherit device;
              inherit neededForBoot;
              inherit options;
              path = "/persist/${path}";
            }
          )
        );

      backup = path: dest: {
        "/backup/${path}" = {
          device = dest;
          options = [ "bind" ];
        };
      };

      backups = paths: lib.attrsets.concatMapAttrs (path: dest: backup path dest) paths;
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
    // subvol {
      inherit device;
      path = "/nix";
      neededForBoot = true;
      options = btrfsOptions ++ [ "noatime" ];
    }
    // persist {
      inherit device;
      neededForBoot = true;
      options = btrfsRWOnly;
      paths = [
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
      ];
    }
    // persist {
      inherit device;
      neededForBoot = false;
      options = btrfsOptions;
      paths = [
        # for flatpak
        "var/lib/flatpak"

        # for accounts
        "home/nyarla/.cache/appimage-run"
        "home/nyarla/.cache/nvim"
        "home/nyarla/.config/protonfixes"
        "home/nyarla/.local/share/Steam"
        "home/nyarla/.local/share/containers"
        "home/nyarla/.local/share/flatpak"
        "home/nyarla/.local/share/nvim"
        "home/nyarla/.local/share/waydroid"
        "home/nyarla/.mozilla"
        "home/nyarla/.steam"
        "home/nyarla/Applications"
        "home/nyarla/Programming"
      ];
    }
    // backups {
      "Applications" = "/persist/home/nyarla/Applications";
      "Development" = "/persist/home/nyarla/Development";
      "Documents" = "/persist/home/nyarla/Documents";
      "NixOS" = "/persist/etc/nixos";
      "Programming" = "/persist/home/nyarla/Programming";
      "Sources/DAW" = "/persist/home/nyarla/Sources/DAW";
      "Sync" = "/persist/home/nyarla/Sync/Backup";
      "Thunderbird" = "/persist/home/nyarla/.thunderbird";
    };

  # btrfs settings
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [
    "/nix"

    "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Calibre"
    "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Music"
    "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/eBooks"

    "/persist/etc"
    "/persist/etc/nixos"

    "/persist/home/nyarla/.cache/appimage-run"
    "/persist/home/nyarla/.cache/nvim"
    "/persist/home/nyarla/.config/protonfixes"
    "/persist/home/nyarla/.local/share/Steam"
    "/persist/home/nyarla/.local/share/containers"
    "/persist/home/nyarla/.local/share/flatpak"
    "/persist/home/nyarla/.local/share/nvim"
    "/persist/home/nyarla/.local/share/waydroid"
    "/persist/home/nyarla/.mozilla"
    "/persist/home/nyarla/.steam"
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
          "Development"
          "Documents"
          "Downloads"
          "Programming"
          "Reports"
          "Sources"
          "Sync"

          # cache
          ".cache/act"
          ".cache/actcache"
          ".cache/appimage-run"
          ".cache/nix"
          ".cache/nvim"
          ".cache/wine"
          ".cache/winetricks"

          # .config
          ".config/Bitwarden"
          ".config/EDRLab.ThoriumReader"
          ".config/GIMP"
          ".config/Kvantum"
          ".config/MusicBrainz"
          ".config/Thunar"
          ".config/Valve"
          ".config/Yubico"
          ".config/act"
          ".config/aseprite"
          ".config/blender"
          ".config/blogsync"
          ".config/calibre"
          ".config/dconf"
          ".config/deadbeef"
          ".config/easytag"
          ".config/fcitx5"
          ".config/flatpak"
          ".config/gh"
          ".config/google-chrome"
          ".config/gtk-2.0"
          ".config/gtk-3.0"
          ".config/gtk-4.0"
          ".config/gyazo"
          ".config/hypr"
          ".config/inkscape"
          ".config/lxqt"
          ".config/nvim"
          ".config/protonfixes"
          ".config/pulse"
          ".config/rclone"
          ".config/remmina"
          ".config/simple-scan"
          ".config/syncthing"
          ".config/tmux"
          ".config/unity3d"
          ".config/unityhub"
          ".config/vlc"
          ".config/whipper"
          ".config/wivrn"
          ".config/xfce4"

          # .local
          ".local/share/ALCOM"
          ".local/share/Steam"
          ".local/share/TelegramDesktop"
          ".local/share/Trash"
          ".local/share/VRChatCreatorCompanion"
          ".local/share/applications"
          ".local/share/com.anatawa12.vrc-get-gui"
          ".local/share/com.poppingmoon.aria"
          ".local/share/containers"
          ".local/share/fcitx5"
          ".local/share/fonts"
          ".local/share/krita"
          ".local/share/libcskk"
          ".local/share/mime"
          ".local/share/nvim"
          ".local/share/pixelorama"
          ".local/share/remmina"
          ".local/share/unity3d"
          ".local/share/vlc"
          ".local/share/waydroid"
          ".local/share/zrythm"

          # state
          ".local/state/wireplumber"

          # application
          ".android"
          ".mozilla"
          ".pki"
          ".steam"
          ".thunderbird"

          # credentials
          (secure ".gnupg")
          (secure ".local/share/keyrings")
          (secure ".ssh")
          (secure ".wrangler")
        ];
      files = [
        # development
        ".npmrc"

        # creative
        ".config/kritadisplayrc"
        ".config/kritarc"
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
        TIMELINE_LIMIT_HOURLY = 1;
        TIMELIME_DAILY = 7;
        TIMELINE_WEEKLY = 0;
        TIMELINE_MONTHLY = 0;
        TIMELINE_YEARLY = 0;
      };

      snapshots = paths: lib.attrsets.concatMapAttrs (n: v: { "${n}" = snapshot v; }) paths;
    in
    snapshots {
      data-music = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Music";
      data-calibre = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Calibre";
      data-ebooks = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/eBooks";

      etc-nixos = "/persist/etc/nixos";

      home-nyarla = "/persist/home/nyarla";
      home-nyarla-applications = "/persist/home/nyarla/Applications";
      home-nyarla-programming = "/persist/home/nyarla/Programming";

      var-lib = "/persist/var/lib";
    };
}
