{ nixpkgs, stable, ... }:
final: prev: {
  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  inherit (stable.legacyPackages.x86_64-linux) deadbeef;

  llama-cpp-rocm = prev.llama-cpp-rocm.overrideAttrs {
    checkPhase = "true";
  };

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
    (prev.whipper.override { inherit python3; }).overrideAttrs (finalAttrs: {
      postPatch = ''
        sed -i 's|cd-paranoia|${prev.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
      '';

      propagatedBuildInputs =
        (builtins.filter (x: x.pname != "setuptools") (finalAttrs.propagatedBuildInputs or [ ]))
        ++ (with python3.pkgs; [
          setuptools_80
        ]);
    });

  wivrn-stable = nixpkgs.legacyPackages.x86_64-linux.pkgs.wivrn.overrideAttrs (finalAttrs: {
    patches = (finalAttrs.patches or [ ]) ++ [ ../patches/wivrn-no-backup-openvr-compat-path.patch ];
  });

  xdg-desktop-portal-luminous = prev.xdg-desktop-portal-luminous.overrideAttrs (finalAttrs: rec {
    version = "0.1.21";
    src = prev.fetchFromGitHub {
      owner = "waycrate";
      repo = "xdg-desktop-portal-luminous";
      rev = "5674aa3b89cc3456085909ce0c9a4d701d8e5981";
      hash = "sha256-m1/PmGj1ZZJdH9AiUxe+6hVs0cwGuegY56gFeWSswA4=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname;
      inherit src version;
      hash = "sha256-N6TteUB3AC+LNxglvgQQ4RxRSaZk6E0f42BbYd3d+Rk=";
    };
  });

  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
