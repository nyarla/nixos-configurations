{ pkgs, ... }: {
  home.packages = with pkgs; [
    # cloud toolchain
    google-cloud-sdk
    awscli
    goaccess
    gh

    # container toolchain
    linuxkit
    act
    actionlint

    # compiler
    binutils
    clang-tools
    gdb
    pkg-config
    stdenv.cc

    # go
    go
    gotools

    # nim
    nim
    nimlsp

    # rust
    rustup

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

    # java
    openjdk

    # nix
    nixfmt
    rnix-lsp
    deadnix
    statix

    # editor
    neovim
    editorconfig-core-c

    # vcs
    git-lfs
    mercurial
    subversion
    cvs

    # website
    hugo

    # misc
    mecab
    openssl
  ];
}
