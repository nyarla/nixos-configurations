{ pkgs, ... }: {
  users.users.nyarla.extraGroups = [
    "audio"
    "disk"
    "input"
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
