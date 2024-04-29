{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides" { } ''
    mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

    ${lib.concatMapStrings (p: ''
      if test -d ${p}/share/gsettings-schemas; then
        find ${p}/share/gsettings-schemas -name '*.xml' \
          -exec cp -rf {} $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/ \;
      fi
    '') config.home.packages}

    ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
  '';
in
{
  xdg.configFile."profile.d/gsettings.sh" = {
    text = ''
      rm -rf $HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
      mkdir -p $HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

      cp -RLf $NIX_GSETTINGS_OVERRIDES_DIR/*.xml \
        $HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

      cp -RLf ${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/*.xml \
        $HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

      ${pkgs.glib.dev}/bin/glib-compile-schemas \
        $HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

      export NIX_GSETTINGS_OVERRIDES_DIR=$HOME/.local/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
    '';
  };
}
