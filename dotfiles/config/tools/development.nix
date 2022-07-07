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
    pkgconfig
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
    python3
    yarn

    # perl
    perl
    perlPackages.Appcpanminus
    perlPackages.PerlTidy
    nix-generate-from-cpan

    # java
    openjdk

    # nix
    nixfmt
    rnix-lsp
    deadnix
    statix

    # editor
    neovim
    neovim-remote
    editorconfig-core-c

    # vcs
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
