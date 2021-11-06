{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg_utils libnotify gksu ];
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

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "nyarla";
          extraConfig = ''
            [greeter]
            show-password-label = true
            password-label-text = nyarla:
            invalid-password = invalid
            show-input-cursor = true
            password-alignment = right

            [greeter-hotkeys]
            mod-key = control
            shutdown-key = s
            restart-key = r

            [greeter-theme]
            text-color = "#FFFFFF"
            error-color = "#CC0000"

            password-color = "#FFFFFF"
            password-background-color = "#000000"
            password-border-width = 0px
            password-border-radius = 0em

            window-color = "#000000"
            border-color = "#000000"
            border-width = 0px
            layout-space = 8

            background-image-size = cover
            background-image = "${
              pkgs.fetchurl {
                url =
                  "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-stripes-logo.png";
                sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";
              }
            }" 
          '';
        };
      };
    };
  };
}
