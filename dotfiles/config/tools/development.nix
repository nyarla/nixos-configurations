{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # credential manager
    proton-pass-cli

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

    # vcs
    git-lfs

    # linter
    actionlint
    ghalint
    zizmor

    # misc
    openssl
    sec
    gemini-cli-pinned
  ];
}
