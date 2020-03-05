{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stdenv.cc
    go goimports dep
    rustup
    nodejs yarn 
    deno-land
    elmPackages.elm-format
    perl perlPackages.Appcpanminus
    ruby
    openjdk
  ]; 

  environment.etc = with pkgs; {
    openjdk.source = openjdk;
  };
}
