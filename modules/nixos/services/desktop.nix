{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.services.desktop;
in
{
  options.mod.services.desktop = {
    enable = mkEnableOption "Enable services for Desktop apps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dconf-editor
      mate-polkit
    ];

    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [
      dconf-editor
      mate-polkit
    ];

    services.accounts-daemon.enable = true;
    services.gnome.glib-networking.enable = true;
    services.gnome.gnome-keyring.enable = true;
    services.system-config-printer.enable = true;

    programs.dconf.enable = true;
    programs.seahorse.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.session.enableGnomeKeyring = true;

    security.polkit = {
      enable = true;
      enablePkexecWrapper = true;
    };
  };
}
