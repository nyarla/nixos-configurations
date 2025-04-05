{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # container toolchain
    act

    # compiler
    clang-tools
    binutils
    gdb
    pkg-config
    stdenv.cc

    # go
    go

    # python3
    python3

    # perl
    perl-shell

    # nix
    nurl

    # editor
    editorconfig-core-c
    nvim-run
    devenv

    # vcs
    git-lfs

    # misc
    openssl
  ];
}
