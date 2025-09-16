let
  theme = import ../../../lib/theme.nix;
in

with theme;

{
  black = gray05;
  red = red65;
  green = green85;
  yellow = yellow85;
  blue = blue85;
  magenta = magenta95;
  cyan = cyan85;
  white = gray95;

  hl_black = gray65;
  hl_red = red75;
  hl_green = green90;
  hl_yellow = yellow90;
  hl_blue = blue90;
  hl_magenta = magenta90;
  hl_cyan = cyan90;
  hl_white = gray100;
}
