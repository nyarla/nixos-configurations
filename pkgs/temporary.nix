_: final: prev: {
  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  fluent-icon-theme = prev.fluent-icon-theme.overrideAttrs (_: {
    version = "2025-06-15"; # last confirm date
    src = prev.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-icon-theme";
      rev = "e8ac55a5eb7c785e7b27519a97fd7a3ca33e9974";
      hash = "sha256-0WtjJ3B3qIgP0vfg7s6fy7Ygg8Gf2TOMARe/m+NxyM8=";
    };

    preFixup = ''
      ln -sf $out/share/icons/Fluent/22/actions/application-menu.svg \
        $out/share/icons/Fluent/22/categories/preferences-other-symbolic.svg

      ln -sf $out/share/icons/Fluent-dark/22/actions/application-menu.svg \
        $out/share/icons/Fluent-dark/22/categories/preferences-other-symbolic.svg
    '';
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

  voicevox-engine = prev.voicevox-engine.override { python3Packages = prev.python312Packages; };
  waydroid = prev.waydroid.override { python3Packages = prev.python312Packages; };
  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
