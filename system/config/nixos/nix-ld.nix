{ pkgs, lib, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    acl
    attr
    bzip2
    curl
    libsodium
    libssh
    libxcrypt
    libxml2
    openssl
    pkgconfig
    stdenv.cc.cc.lib
    stdenv.cc.libc
    systemd
    util-linux
    xz
    zlib
    zstd
  ];
}
