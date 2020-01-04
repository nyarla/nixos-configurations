{ pkgs, ... }:
{
  imports = [
    ../config/per-hardware/Hyper-V.nix
    ../config/per-host/Nix-V.nix
     
    ../config/per-country/jp.nix
    
    # ../config/per-desktop/Hyper-V.nix
    # ../config/per-desktop/HiDPI.nix
    # ../config/per-desktop/bspwm.nix

    # ../config/per-bundle/applications.nix
    # ../config/per-bundle/fonts.nix
    # ../config/per-bundle/themes.nix

    ../config/per-bundle/development.nix    
    ../config/per-bundle/shell.nix

    ../config/per-account/nyarla.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
  ];
}
