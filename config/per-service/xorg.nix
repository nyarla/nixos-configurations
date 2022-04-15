{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg_utils libnotify sx ];
in {
  imports = [ ./fonts.nix ./gnome-compatible.nix ./gsettings.nix ./picom.nix ];

  environment.systemPackages = utils;
  console.useXkbConfig = true;

  systemd.services.displayManagerCompat = {
    enable = true;
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
