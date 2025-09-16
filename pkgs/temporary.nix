{ nixpkgs }:
final: prev: {
  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  fluent-icon-theme = prev.fluent-icon-theme.overrideAttrs (_: {
    version = "2025-06-15"; # last confirm date
    src = prev.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-icon-theme";
      rev = "3749c9b4715edf28f8f937c5786cce04d8e51cb2";
      hash = "sha256-sKeeXI/2FXOIXP81hLPMbaVoCuD72zR6TrODS2HaeVU=";
    };
  });

  hyprlandPlugins =
    let
      src = prev.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprland-plugins";
        rev = "5ff379f4e525183cc6766ea95764b52ec97d8966";
        hash = "sha256-6jAtMjnWq8kty/dpPbIKxIupUG+WAE2AKMIKhxdLYNo=";
      };
    in
    {
      hyprbars = prev.hyprlandPlugins.hyprbars.overrideAttrs (old: {
        src = "${src}/${old.pname}";
      });

      hyprexpo = prev.hyprlandPlugins.hyprexpo.overrideAttrs (old: {
        src = "${src}/${old.pname}";
      });
    };

  whipper =
    let
      python3 =
        let
          packageOverrides = _: before: {
            pycdio = before.pycdio.overridePythonAttrs (_: {
              nativeBuildInputs = with prev; [
                pkg-config
                swig
              ];

              checkPhase = "true";
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

  voicevox-engine = prev.voicevox-engine.override { python3Packages = prev.python312Packages; };
  waydroid = prev.waydroid.override { python3Packages = prev.python312Packages; };
  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
