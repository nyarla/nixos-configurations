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
      lightdm = { enable = true; };
    };
  };
}
