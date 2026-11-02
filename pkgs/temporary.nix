{ nixpkgs, stable, ... }:
final: prev: {
  arion = prev.arion.overrideAttrs {
    postPatch = ''
      substituteInPlace src/nix/modules/nixos/container-systemd.nix \
        --replace-fail "services.journald.console" "services.journald.settings.Journal.TTYPath"
    '';
  };

  inherit (stable.legacyPackages.x86_64-linux) deadbeef;

  llama-cpp-rocm = prev.llama-cpp-rocm.overrideAttrs {
    checkPhase = "true";
  };

  open-webui =
    let
      python3 =
        let
          packageOverrides = _: before: {
            marko = before.marko.overrideAttrs { checkPhase = "true"; };
            posthog = before.posthog.override { mcp = before.mcp_1; };
          };
        in
        prev.python3.override { inherit packageOverrides; };
    in
    prev.open-webui.override { python3Packages = python3.pkgs; };

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

  vital = prev.vital.overrideAttrs rec {
    pname = "vital";
    version = "1.6.4";
    src = prev.fetchzip {
      url = "https://builds.vital.audio/VitalAudio/vital/${
        builtins.replaceStrings [ "." ] [ "_" ] version
      }/VitalInstaller.zip";

      hash = "sha256-w4lHlcqkzPcUm+HmERs8+nLCgP1BWNnMSXqdV9Fyc/Q=";
    };
  };

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
