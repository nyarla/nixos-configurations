{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stdenv.cc
    binutils
    gdb
    clang
    clang-tools
    pkgconfig

    go
    goimports

    nim
    nimlsp

    rustup

    nodejs_latest
    yarn
    # deno-land 
    # elmPackages.elm-format

    perl
    perlPackages.Appcpanminus
    nix-generate-from-cpan

    mecab
    openssl

    openjdk
  ];

  environment.etc = with pkgs; { openjdk.source = openjdk; };
}
