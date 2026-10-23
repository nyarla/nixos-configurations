{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.programs.desktop;
in
{
  options.mod.programs.desktop = {
    enable = mkEnableOption "Enable applications for Desktop environment";
  };

  config = mkIf cfg.enable (
    let
      desktopApps = with pkgs; [
        atril
        engrampa
        eom
        mate-calc
        pluma

        ibis-office

        gcr_3
        gsound
        zenity
      ];
    in
    {
      environment.systemPackages = desktopApps;
      services.dbus.packages = desktopApps;

      services.udisks2.enable = true;
      services.gvfs.enable = true;
      services.tumbler.enable = true;

      programs.xfconf.enable = true;
      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-shares-plugin
          thunar-vcs-plugin
          thunar-volman
        ];
      };

      users.groups.storage = { };
      security.polkit.extraConfig = ''
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
    }
  );
}
