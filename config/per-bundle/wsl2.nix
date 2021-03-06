{ config, pkgs, ... }: {
  imports = [ ../per-desktop/fonts.nix ../per-desktop/uim.nix ];

  environment.systemPackages = with pkgs; [ mlterm xclip syncthing ];

  services.dbus.packages = with pkgs; [ mlterm xclip syncthing ];
}
