{ pkgs, ... }: {
  home.packages = with pkgs; [
    # cloud toolchain
    google-cloud-sdk
    awscli
    flyctl

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

    # java
    openjdk

    # nix
    nurl

    # editor
    neovim
    editorconfig-core-c

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
