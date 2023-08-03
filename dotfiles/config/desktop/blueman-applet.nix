{ pkgs, config, ... }: {
  systemd.user.services.blueman-applet = {
    Unit = {
      Description = "launch blueman-applet";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Environment = [
        "HOME=${config.home.homeDirectory}"

        "LANG=ja_JP.UTF-8"
        "LC_ALL=ja_JP.UTF-8"

        "PATH=/run/current-system/sw/bin:${config.home.profileDirectory}/bin"

        "XCURSOR_PATH=/run/current-system/etc/profiles/per-user/nyarla/share/icons:${config.home.homeDirectory}/.icons/default"
        "XCURSOR_THEME=capitaine-cursors-white"
        "XCURSOR_SIZE=24"

        "XDG_CONFIG_DIRS=/run/current-system/etc/xdg:/etc/profiles/per-user/nyarla/etc/xdg:/etc/xdg"
        "XDG_DATA_DIRS=/run/current-system/sw/share:/etc/profiles/per-user/nyarla/share"

        "XDG_CONFIG_HOME=${config.home.homeDirectory}/.config"
        "XDG_DATA_HOME=${config.home.homeDirectory}/.local/share"

        "WAYLAND_DISPLAY=wayland-0"
      ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
