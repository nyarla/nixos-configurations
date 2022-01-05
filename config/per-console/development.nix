{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stdenv.cc
    stdenv.cc.cc.lib
    binutils
    gdb
    clang
    clang-tools
    pkgconfig
    colordiff

    go
    goimports

    nim
    nimlsp

    rustup

    nodejs_latest
    yarn
    python3
    # deno-land 
    # elmPackages.elm-format

    perl
    perlPackages.Appcpanminus
    perlPackages.PerlTidy
    nix-generate-from-cpan

    mecab
    openssl

    openjdk
  ];

  environment.etc = with pkgs; { openjdk.source = openjdk; };
}
