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
      rev = "85596cd23bd30a068563a4ae6c2fe4a03de2b5e3";
      hash = "sha256-Vqb+II/O/kfC7iUI1Bfsyx8Ex9rYrtVWYlSg04KMfW8=";
    };

    preFixup = ''
      ln -sf $out/share/icons/Fluent/22/actions/application-menu.svg \
        $out/share/icons/Fluent/22/categories/preferences-other-symbolic.svg

      ln -sf $out/share/icons/Fluent-dark/22/actions/application-menu.svg \
        $out/share/icons/Fluent-dark/22/categories/preferences-other-symbolic.svg
    '';
  });

  hyprland = prev.hyprland.overrideAttrs (_: {
    patches = [
      (prev.fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/hyprwm/Hyprland/pull/11136.patch";
        hash = "sha256-eKgjG1rTqOMyzxSeXlWE2Hur6AvMtA3bw7cP7WsZA/g=";
      })
    ];
  });

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
