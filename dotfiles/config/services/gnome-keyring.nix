{ pkgs, lib, ... }: {
  services.gnome-keyring.enable = true;
  systemd.user.services.gnome-keyring.Service.ExecStart = lib.mkForce
    "/run/wrappers/bin/gnome-keyring-daemon --components=pkcs11,secrets,ssh --start --foreground";
}
