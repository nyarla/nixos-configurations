{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # cloud toolchain
    google-cloud-sdk
    awscli
    flyctl
    gh

    # container toolchain
    linuxkit
    act

    # compiler
    clang-tools
    binutils
    gdb
    pkg-config
    stdenv.cc

    # go
    go

    # nim
    nim

    # node.js
    nodejs_latest
    yarn

    # python3
    conda
    python3

    # perl
    nix-generate-from-cpan
    perl
    perl-shell
    perlPackages.Appcpanminus
    perlPackages.PerlTidy

    # nix
    nurl

    # editor
    editorconfig-core-c
    nvim-run
    devenv

    # vcs
    git-lfs
    mercurial
    subversion
    cvs

    # misc
    openssl
  ];
}
