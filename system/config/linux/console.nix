{ pkgs, lib, ... }:
let
  theme = import ../../../lib/theme.nix;
in
{
  console.colors =
    with theme;
    lib.lists.forEach [
      gray00
      red65
      green85
      yellow85
      blue85
      magenta95
      cyan85
      gray95
      gray65
      red75
      green90
      yellow90
      blue90
      magenta90
      cyan95
      gray100
    ] (x: lib.strings.replaceString "#" "" x);

  console.earlySetup = true;
}
