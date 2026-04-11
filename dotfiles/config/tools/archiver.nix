{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bzip2
    cpio
    # dmg2img
    gnutar
    lzip
    asar
    p7zip
    # pbzx
    unrar
    unzip
    # xar
    xz
    zip
    zstd
  ];
}
