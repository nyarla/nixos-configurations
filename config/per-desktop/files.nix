{ config, pkgs, ... }:
let
  apps = (with pkgs.mate; [
    caja
    caja-extensions
    engrampa
    eom
    atril
    pluma
  ]) ++ (with pkgs; [
    gnome3.gnome-font-viewer
    udisks2
    glib
    gnome3.ghex
  ]);
in
{
  environment.systemPackages = apps;
  services.dbus.packages = apps;
  users.groups.storage = { };
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ( action.id === "org.freedesktop.udisks2.encrypted-unlock-system" && subject.isInGroup("storage") ) {
          return polkit.Result.YES;
        }
        if ( (action.id === "org.freedesktop.udisks2.filesystem-mount-system"
          || action.id === "org.freedesktop.udisks2.filesystem-mount") && subject.isInGroup("storage") ) {
          return polkit.Result.YES; 
        }
      });
    '';
  };
  services.gvfs.enable = true;
}
