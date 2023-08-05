_: {
  systemd.user.targets.desktop-session = {
    Unit = {
      Description = "Desktop Session target for Xorg and Wayland";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.targets.desktop-xdg-autostart = {
    Unit = {
      Description = "XDG Autostart for Xorg and Wayland desktop";
      BindsTo = [ "xdg-desktop-autostart.target" ];
      PartOf = [ "desktop-session.target" ];
      After = [ "desktop-session.target" ];
    };
  };

  systemd.user.targets.desktop-session-shutdown = {
    Unit = {
      Description = "Shutdown running Xorg and Wayland Desktop";
      DefaultDependencies = "no";
      StopWhenUnneeded = true;

      Conflict = [
        "graphical-session.target"
        "graphical-session-pre.target"
        "desktop-session.target"
      ];
      After = [
        "graphical-session.target"
        "graphical-session-pre.target"
        "desktop-session.target"
      ];
    };
  };
}
