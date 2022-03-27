{ pkgs, ... }: {
  imports = [ ./fonts.nix ./theme.nix ./gnome-compatible.nix ./gsettings.nix ];
  security.pam.services.swaylock = { };
  environment.systemPackages = with pkgs; [ libsForQt5.qtwayland ];
}
