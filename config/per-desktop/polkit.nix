{ config, pkgs, ... }:
let
  apps = with pkgs; [
    mate.mate-polkit
  ];
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
}
