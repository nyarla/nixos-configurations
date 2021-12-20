{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg_utils libnotify gksu sx ];
in {
  environment.systemPackages = utils;
  console.useXkbConfig = true;

  systemd.user.services.clipboard-keep = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.xclip ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${pkgs.writeShellScript "clipboard-keep.sh" ''
        clipboard=

        while true; do
          content="$(${pkgs.xclip}/bin/xclip -o -selection clipboard 2>/dev/null)"

          if test -z "''${content:-}"; then
            echo -n $clipboard | ${pkgs.xclip}/bin/xclip -i -selection clipboard -rmlastnl
          else
            export clipboard="''${content:-}"
          fi

          sleep 1
        done
      ''}";
    };
  };

  systemd.services.displayManagerCompat = {
    enable = false;
    wants = [ "accounts-daemon.service" ];
    requires = [ "user.slice" ];
    after = [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "user.slice"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true";
      BusName = "org.freedesktop.DisplayManager";
      IgnoreSIGPIPE = "no";
      KeyringMode = "shared";
      KillMode = "mixed";
      StandardError = "inherit";
    };
  };

  services.xserver = {
    enable = true;
    autorun = false;
    libinput.enable = true;
    exportConfiguration = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      lightdm = { enable = false; };
    };
  };

  security.wrappers = {
    "Xorg" = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.xorg.xorgserver}/bin/Xorg";
    };
  };

  nixpkgs.config.packageOverrides = super: rec {
    sx = super.sx.overrideAttrs (old: rec {
      postPatch = ''
        sed -i 's!Xorg!/run/wrappers/bin/Xorg!' sx
      '';
    });
  };
}
