{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stdenv.cc
    gdb

    go
    goimports

    rustup

    nodejs_latest
    yarn
    # deno-land 
    # elmPackages.elm-format

    perl
    perlPackages.Appcpanminus

    openjdk

    vlang
  ];

  environment.etc = with pkgs; { openjdk.source = openjdk; };
}
