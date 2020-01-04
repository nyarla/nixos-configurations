{ pkgs, ... }:
{
  imports = [
    ../config/per-hardware/VirtualBox.nix
    ../config/per-host/NixBox.nix

    ../config/per-country/jp.nix

    ../config/per-software/shell.nix
    ../config/per-software/development.nix
 
    ../config/per-account/nyarla.nix
  ];

  environment.systemPackages = with pkgs; [
    # vimHugeX
    neovim
  ];
}
