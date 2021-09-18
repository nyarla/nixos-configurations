{ pkgs, ... }:
let sync = with pkgs; [ syncthing ];
in {
  imports = [
    ../per-service/avahi.nix
    ../per-service/connman.nix
    ../per-service/docker.nix
    ../per-service/firewall.nix
    ../per-service/kvm.nix
    ../per-service/tailscale.nix
  ];

  environment.systemPackages = sync;
  services.dbus.packages = sync;

  # avahi
  services.avahi.interfaces = [ "wlan0" ];

  # backup
  systemd.services.backup = {
    enable = true;
    description = "Automatic backup by restic and rclone";
    unitConfig = {
      RefuseManualStart = "no";
      RefuseManualStop = "yes";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "backup.sh" ''
        #!${pkgs.bash}/bin/bash

        export HOME=/home/nyarla

        export RESTIC_REPOSITORY=rclone:Teracloud:NyZen9
        export RESTIC_PASSWORD_FILE=$HOME/.config/rclone/restic

        export RESTIC_FORGET_ARGS="--prune --keep-daily 7 --keep-weekly 2 --keep-monthly 3"
        export RESTIC_BACKUP_ARGS="--exclude-file $HOME/.config/rclone/ignore"

        backup() {
          local target=$1 

          ${pkgs.restic}/bin/restic backup -o ${pkgs.rclone}/bin/rclone \
            -H NyZen9 $RESTIC_BACKUP_ARGS $1

          ${pkgs.restic}/bin/restic forget -o ${pkgs.rclone}/bin/rclone \
            $RESTIC_FORGET_ARGS
        }

        backup $HOME/local
        backup $HOME/Music
      '';
      User = "nyarla";
      Group = "users";
    };
  };

  systemd.timers.backup = {
    enable = true;
    description = "Timer for automatic backup by restic";
    wantedBy = [ "timer.target" "multi-user.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      Persistent = "true";
    };
  };

  # syncthing
  systemd.services.syncthing = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    wants = [ "network.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    path = [ pkgs.syncthing ];
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

  # firewall
  networking.firewall.interfaces = {
    "tailscale0" = {
      allowedTCPPorts = [
        # calibre-server
        8085
      ];
    };
    "wlan0" = {
      allowedTCPPorts = [
        # syncthing
        22000
      ];
      allowedUDPPorts = [
        # service
        22000
        21027
      ];
    };
  };

}
