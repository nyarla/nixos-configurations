{ config, ... }: {
  systemd.user.services._1password = {
    Unit = {
      Description = "Autostart for 1password";
      After = [ "graphical-session.target" "lxqt-panel.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };

    Service = {
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
      ExecStart = "/run/current-system/sw/bin/1password --silent";
    };
  };
}
