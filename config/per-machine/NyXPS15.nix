{ config, pkgs, ... }:
{
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.supportedLocales = [
    "ja_JP.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  networking.hostId = "71ca914d";
  networking.hostName = "NyXPS15";
  
  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.fileSystems = [ "/" "/nix" "/home" "/run/media/nyarla/LINUX" ];
  services.btrfs.autoScrub.interval = "*-*-* 03:00:00";

  services.snapper.cleanupInterval = "1d";
  services.snapper.snapshotInterval = "*-*-* 0:00,10,20,30,40,50:00";
  services.snapper.filters = ''
    /home/*/.cache
    /home/*/.compose-cache
  '';
  services.snapper.configs = {
    nixos = {
      subvolume = "/";
      extraConfig = ''
        NUMBER_LIMIT="20"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
      '';
    };

    home = {
      subvolume = "/home";
      extraConfig = ''
        ALLOW_USER="nyarla"
        NUMBER_LIMIT="20"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
      '';
    };

    linux = {
      subvolume = "/run/media/nyarla/LINUX";
        extraConfig = ''
        ALLOW_USER="nyarla"
        NUMBER_LIMIT="20"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
      '';
    };
  };

  systemd.mounts = [
    { enable = true;
      what   = "/dev/disk/by-uuid/a31a21a8-4dee-43c2-aa78-9388e42875e8";
      where  = "/run/media/nyarla/LINUX";
      type   = "btrfs";
      mountConfig = {
        TimeoutSec = 10;
        Options = [ "noauto" "x-systemd.automount" "noatime" "ssd" "autodefrag" "compress-force=lzo" "space_cache" ];
      };
    }
  ];

  systemd.automounts = [
    { enable = true;
      where  = "/run/media/nyarla/LINUX";
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        DirectoryMode = "0755";
      };
    }
  ];

  systemd.services.syncthing = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network.target" ];
    after = [
      "network-online.target"
      "systemd-resolved.service"
    ];
    path = [
      pkgs.syncthing
    ];
    serviceConfig = {
      Type = "simple";
      User = "nyarla";
      Group = "users";
      ExecStart = "${pkgs.writeScript "synthing" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.syncthing}/bin/syncthing -no-browser
      ''}";
    };
  };

# systemd.services.backup = {
#   enable = true;
#   description = "Automatic backup by rsync";
#   unitConfig = {
#     RefuseManualStart = "no";
#     RefuseManualStop = "yes";
#   };
#   serviceConfig = {
#     Type = "oneshot";
#     ExecStart = "${pkgs.rsync}/bin/rsync -a /run/media/nyarla/LINUX/Encrypted/ /run/media/nyarla/DATA/Dropbox/Backup/";
#     User = "nyarla";
#     Group = "users";
#   };
# };
  
  systemd.services.backup = {
    enable = true;
    description = "Automatic backup by restic";
    unitConfig = {
      RefuseManualStart = "no";
      RefuseManualStop = "yes";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeScript "backup" ''
        #!${pkgs.stdenv.shell}

        export HOME=/home/nyarla
        export tag="$(date +%Y-%m-%d)"

        for repo in /run/media/nyarla/DATA/Backup rclone:teracloud:Backup ; do
        # /etc/nixos
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/nixos backup \
          /etc/nixos

        # ~/Documents
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/Documents backup \
          /home/nyarla/Documents

        # ~/local/dev/src/github.com/nyarla
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/dev backup \
          /home/nyarla/local/dev/src/github.com/nyarla

        # ~/local/dotfiles
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/dotfiles backup \
          /home/nyarla/local/dotfiles

        # ~/local/dotvim
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/dotvim backup \
          /home/nyarla/local/dotvim

        # /run/media/nyarla/LINUX/Wine
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/Wine backup \
          /run/media/nyarla/LINUX/Wine

        # /run/media/nyarla/LINUX/Files
        ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
          --tag=$tag \
          --password-file=/etc/restic/password \
          --exclude-file=/etc/restic/ignore \
          -r $repo/Files backup \
          /run/media/nyarla/LINUX/Files
        done

        for repo in /run/media/nyarla/DATA/Backup rclone:teracloud:Backup ; do
          for backup in nixos Documents dev dotfiles dotvim Wine Files; do
            ${pkgs.restic}/bin/restic -o rclone.program="${pkgs.rclone}/bin/rclone" \
              --password-file=/etc/restic/password \
              -r $repo/$backup \
              forget \
                --prune \
                --keep-daily 7 \
                --keep-weekly 2 \
                --keep-monthly 3
          done
        done
      ''}";
      User = "nyarla";
      Group = "users";
    };
  };

  systemd.timers.backup = {
    enable = true;
    description = "Timer for automatic backup by restic";
    wantedBy = [ "timer.target" "multi-user.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 01:00:00";
      Persistent = "true";
    };
  };

  services.udev.extraRules = ''
    ENV{ID_FS_TYPE}=="btrfs", ENV{UDISKS_IGNORE}="1"
    ENV{ID_FS_UUID}=="a175f3a2-455e-4ea1-b063-82103c6835fc", ENV{UDISKS_IGNORE}="1"
    ENV{ID_FS_UUID}=="a31a21a8-4dee-43c2-aa78-9388e42875e8", ENV{UDISKS_IGNORE}="1"
  '';

  imports = [
    ../per-hardware/bluetooth.nix
    ../per-hardware/console.nix
    ../per-hardware/systemd-boot.nix
    ../per-hardware/intel-nvidia.nix
    ../per-hardware/keyboard-us.nix
    ../per-hardware/pulseaudio.nix
    ../per-hardware/tcp-bbr.nix
    ../per-hardware/thunderbolt.nix
    ../per-hardware/XPS-9560-JP.nix
    
    # ../per-service/avahi.nix
    ../per-service/android.nix
    ../per-service/firewall.nix
    ../per-service/printer.nix
    ../per-service/vpn.nix
  ];
}
