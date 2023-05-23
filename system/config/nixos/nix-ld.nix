{ pkgs, lib, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    acl
    attr
    bzip2
    curl
    libsodium
    libssh
    libxml2
    openssl
    stdenv.cc.cc
    stdenv.cc.cc.lib
    stdenv.cc.libc
    systemd
    util-linux
    xz
    zlib
    zstd
  ];
}
