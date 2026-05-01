{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # sandboxed app
    fence-sandboxed

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
    bun
    editorconfig-core-c
    nodejs

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
