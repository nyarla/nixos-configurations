{ lib, pkgs, ... }:
let
  toKV = lib.generators.toKeyValue { };

  aafont = (import ./aafont.nix) { inherit (pkgs.stdenv) system; };
  main = (import ./main.nix) { inherit color pkgs; };
  color = import ./color.nix;
  key = import ./key.nix;
in
{
  home = {
    packages = with pkgs; [ mlterm ];
    file = {
      ".mlterm/aafont".text = toKV aafont;
      ".mlterm/color".text = toKV color;
      ".mlterm/key".text = toKV key;
      ".mlterm/main".text = toKV main;
    };
  };
}
