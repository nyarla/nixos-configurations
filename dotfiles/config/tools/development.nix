{ pkgs, ... }: {
  home.packages = with pkgs; [
    # cloud toolchain
    google-cloud-sdk
    awscli
    flyctl

    # container toolchain
    linuxkit
    act
    actionlint

    # compiler
    clang-tools
    binutils
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

    # lua
    luajitPackages.luacheck

    # editor
    neovim
    editorconfig-core-c
    editorconfig-checker

    # setting files
    hadolint
    yamllint
    cmake-format
    taplo
    shellcheck

    # vcs
    git-lfs
    mercurial
    subversion
    cvs

    # misc
    mecab
    openssl
  ];
}
