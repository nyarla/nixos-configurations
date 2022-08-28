{ lib, pkgs, ... }:
let
  toKV = lib.generators.toKeyValue { };

  aafont = import ./aafont.nix;
  color = import ./color.nix;
  key = import ./key.nix;
  main = (import ./main.nix) { inherit color pkgs; };

  terminfo = pkgs.terminfo-mlterm-256color;

in {
  home.packages = with pkgs; [ mlterm ];

  home.file.".mlterm/aafont".text = toKV aafont."${pkgs.stdenv.system}";
  home.file.".mlterm/color".text = toKV color;
  home.file.".mlterm/key".text = toKV key;
  home.file.".mlterm/main".text = toKV main;
  home.file.".terminfo".source = "${terminfo}/share/terminfo";
}
