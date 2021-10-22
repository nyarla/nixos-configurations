{ pkgs, ... }:
let sync = with pkgs; [ syncthing mosh ];
in {
  imports = [
    ../per-service/avahi.nix
    ../per-service/connman.nix
    ../per-service/docker.nix
    ../per-service/firewall.nix
    ../per-service/kvm.nix
    ../per-service/printer.nix
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

        export RESTIC_REPOSITORY=rclone:Teracloud:NixOS
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

  # samba
  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    securityType = "user";
    package = pkgs.samba4Full;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nixos
      netbios name = nixos
      security = user
      use sendfile = yes
      hosts allow = 192.168.254.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      data = {
        "path" = "/run/media/nyarla/data";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "no";
      };
      local = {
        "path" = "/home/nyarla/local";
        "browseable" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "no";
        "read only" = "no";
      };
    };
  };

  # sshd
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    permitRootLogin = "no";
    openFirewall = false;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    listenAddresses = [{
      addr = "0.0.0.0";
      port = 2222;
    }];
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
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  networking.firewall.interfaces = {
    "tailscale0" = {
      allowedTCPPorts = [
        # calibre-server
        8085

        # sshd
        2222
      ];
      allowedUDPPortRanges = [{
        from = 60000;
        to = 61000;
      }];
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
