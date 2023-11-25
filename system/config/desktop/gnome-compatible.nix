{ config, pkgs, ... }: {
  environment.systemPackages =
    (with pkgs.gnome; [ zenity dconf-editor gnome-keyring ])
    ++ (with pkgs; [ gsound gcr ]);

  services = {
    accounts-daemon.enable = true;
    dbus.enable = true;
    system-config-printer.enable = true;

    gnome = {
      gnome-settings-daemon.enable = true;
      glib-networking.enable = true;
    };
  };

  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  services.upower.enable = config.powerManagement.enable;

  security.pam.services.keyring.enableGnomeKeyring = true;
  security.wrappers.gnome-keyring-daemon = {
    owner = "root";
    group = "root";
    capabilities = "cap_ipc_lock=ep";
    source = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon";
  };
}
