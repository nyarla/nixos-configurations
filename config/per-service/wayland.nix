{ pkgs, ... }: {
  imports = [ ./gnome-compatible.nix ];
  security.pam.services.swaylock = { };
}
