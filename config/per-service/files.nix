{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ glib gnome3.gvfs udisks2 ];

  services.gvfs.enable = true;

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

  environment.etc."profile.d/caja" = {
    text = ''
      export CAJA_EXTENSION_DIRS=$CAJA_EXTENSION_DIRS''${CAJA_EXTENSION_DIRS:+:}${config.system.path}/lib/caja/extensions-2.0
    '';
  };
}
