{
  config,
  pkgs,
  lib,
  ...
}:
let
  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides" { } ''
    mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    cp -rf ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml \
      $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

    ${lib.concatMapStrings (p: ''
      if test -d ${p}/share/gsettings-schemas; then
        find ${p}/share/gsettings-schemas -name '*.xml' \
          -exec cp -rfH {} $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/ \;
      fi
    '') (lib.lists.remove null config.environment.systemPackages)}

    ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
  '';
in
{
  environment.etc."profile.d/gsettings.sh" = {
    text = ''
      export NIX_GSETTINGS_OVERRIDES_DIR=${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
    '';
  };
}
