{ nixpkgs, stable, ... }:
final: prev: {
  inherit (stable.legacyPackages.x86_64-linux.pkgs) deadbeef;

  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  whipper =
    let
      python3 =
        let
          packageOverrides = _: before: {
            pycdio = before.pycdio.overridePythonAttrs (_: {
              disabledTests = [
                "ISO9660"
                "CdioTest"
              ];
            });
          };
        in
        prev.python3.override { inherit packageOverrides; };
    in
    (prev.whipper.override { inherit python3; }).overrideAttrs (_: {
      postPatch = ''
        sed -i 's|cd-paranoia|${prev.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
      '';
    });

  wivrn-stable = nixpkgs.legacyPackages.x86_64-linux.pkgs.wivrn;

  waydroid = prev.waydroid.override { python3Packages = prev.python312Packages; };

  xdg-desktop-portal-luminous = prev.xdg-desktop-portal-luminous.overrideAttrs (finalAttrs: rec {
    version = "0.1.17";
    src = prev.fetchFromGitHub {
      owner = "waycrate";
      repo = "xdg-desktop-portal-luminous";
      tag = "v${version}";
      hash = "sha256-BKzV7vUdCtqhjm8Ir0Uo/ozacTVZtzzlncPwTW1QMEw=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname;
      inherit src version;
      hash = "sha256-NSoFmDsQgHw/WI6Z6iqzT2czIAzeZhHvvWySf/NC0mA=";
    };
  });

  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
