{ pkgs, ... }:
let
  mateApps = with pkgs.mate; [
    atril
    engrampa
    eom
    mate-polkit
    pluma
  ];
in
{
  environment.systemPackages = mateApps;
  services.dbus.packages = mateApps;

  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-archive-plugin
    ];
  };

  programs.xfconf.enable = true;

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
