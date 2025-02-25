_: _: prev: {
  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  fluent-icon-theme = prev.fluent-icon-theme.overrideAttrs (_: {
    version = "2025-02-11";
    src = prev.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Fluent-icon-theme";
      rev = "7d20e2d2a2876dc859ec166bde7508cd367186b4";
      hash = "sha256-gLEKdg0k9WMm9UUDE/q9cGk1sR3BT2/P6MikgONUxss=";
    };
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
}
