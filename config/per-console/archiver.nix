{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zip
    unzip
    bzip2
    p7zip
    gnutar
    lzma
    unrar
    xar
    cpio
    dmg2img
    pbzx
    nodePackages.asar
  ];
}
