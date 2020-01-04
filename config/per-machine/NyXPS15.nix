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
  services.btrfs.autoScrub.fileSystems = [ "/" "/nix" "/home" ];
  services.btrfs.autoScrub.interval = "*-*-* 03:00:00";

  services.snapper.cleanupInterval = "*-*-* 04:00:00";
  services.snapper.snapshotInterval = "*-*-* *:00,10,20,30,40,50:00";
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
  };

  systemd.mounts = [
    { enable = true;
      what   = "/dev/disk/by-uuid/a175f3a2-455e-4ea1-b063-82103c6835fc";
      where  = "/run/media/nyarla/DATA";
      type   = "btrfs";
      mountConfig = {
        TimeoutSec = 10;
        Options = [ "noauto" "x-systemd.automount" "noatime" "autodefrag" "compress-force=lzo" "space_cache" ];
      };
    }
    { enable = true;
      what   = "/dev/disk/by-uuid/a31a21a8-4dee-43c2-aa78-9388e42875e8";
      where  = "/run/media/nyarla/LINUX";
      type   = "btrfs";
      mountConfig = {
        TimeoutSec = 10;
        Options = [ "noauto" "x-systemd.automount" "noatime" "autodefrag" "compress-force=lzo" "space_cache" ];
      };
    }
  ];

  systemd.automounts = [
    { enable = true;
      where  = "/run/media/nyarla/DATA";
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        DirectoryMode = "0755";
      };
    }
    { enable = true;
      where  = "/run/media/nyarla/LINUX";
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        DirectoryMode = "0755";
      };
    }
  ];

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
    
    ../per-service/avahi.nix
    ../per-service/firewall.nix
    ../per-service/printer.nix
  ];
}
