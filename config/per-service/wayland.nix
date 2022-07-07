{ pkgs, ... }: {
  imports = [ ./fonts.nix ./gnome-compatible.nix ];
  security.pam.services.swaylock = { };
}
