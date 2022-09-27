{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [ glib udisks2 ]
    ++ (with pkgs.gnome; [ gvfs ghex gnome-disk-utility gnome-font-viewer ])
    ++ (with pkgs.xfce; [ exo thunar garcon libxfce4ui xfconf ])
    ++ (with pkgs.mate; [ atril engrampa eom mate-polkit pluma ]);

  services.gvfs.enable = true;
  services.tumbler.enable = true;

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
