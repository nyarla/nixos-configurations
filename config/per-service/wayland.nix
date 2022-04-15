{ pkgs, ... }: {
  imports = [ ./fonts.nix ./gnome-compatible.nix ./gsettings.nix ];
  security.pam.services.swaylock = { };
}
