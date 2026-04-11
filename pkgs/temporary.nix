{ nixpkgs, stable, ... }:
final: prev: {
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

  xdg-desktop-portal-luminous = prev.xdg-desktop-portal-luminous.overrideAttrs (finalAttrs: rec {
    version = "0.1.18";
    src = prev.fetchFromGitHub {
      owner = "waycrate";
      repo = "xdg-desktop-portal-luminous";
      rev = "31ed88fdc06cfb8b6b12327d1c09261000c53fbc";
      hash = "sha256-Or/w+XBRfXcMJW2Ua0CW7b/tRJPAvxopX7OwBZBDRuI=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname;
      inherit src version;
      hash = "sha256-D8gFJMx2QTVUizUr/mm6VALkeiBsHek30C40DUOqcXs=";
    };
  });

  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
