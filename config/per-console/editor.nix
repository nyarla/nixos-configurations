{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vimHugeX
    editorconfig-core-c

    nixpkgs-fmt
    rnix-lsp
  ];

  services.dbus.packages = with pkgs; [
    vimHugeX
  ];
}
