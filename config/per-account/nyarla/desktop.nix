{ pkgs, ... }: {
  users.users.nyarla.extraGroups = [
    "audio"
    "disk"
    "input"
    "lightdm"
    "lp"
    "networkmanager"
    "nm-openvpn"
    "render"
    "scanner"
    "storage"
    "tty"
    "video"
  ];
}
