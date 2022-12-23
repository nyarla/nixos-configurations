{ config, pkgs, ... }: {
  environment.systemPackages =
    (with pkgs.gnome; [ zenity dconf-editor gnome-keyring ])
    ++ (with pkgs; [ gtk3 dconf gsound gcr ]);

  services.dbus.enable = true;

  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  services.accounts-daemon.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.glib-networking.enable = true;
  services.system-config-printer.enable = true;
  services.upower.enable = config.powerManagement.enable;

  security.pam.services.keyring.enableGnomeKeyring = true;

  security.wrappers.gnome-keyring-daemon = {
    owner = "root";
    group = "root";
    capabilities = "cap_ipc_lock=ep";
    source = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon";
  };
}
