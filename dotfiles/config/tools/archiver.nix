{ pkgs, ... }: {
  home.packages = with pkgs; [
    bzip2
    cpio
    dmg2img
    gnutar
    lzma
    nodePackages.asar
    p7zip
    pbzx
    unrar
    unzip
    xar
    zip
    zstd
  ];
}
