_: super:
let
  require = path: super.callPackage (import path);
in
{
  bristol = super.bristol.overrideAttrs (old: rec {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  dqlite = super.dqlite.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.lz4.dev ];
  });

  fcitx5 = super.fcitx5.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      inherit (old.src) owner repo;
      rev = "5.1.12";
      hash = "sha256-Jk7YY6nrY1Yn9KeNlRJbMF/fCMIlUVg/Elt7SymlK84=";
    };
  });

  whipper =
    let
      python3 =
        let
          packageOverrides = final: prev: {
            pycdio = prev.pycdio.overridePythonAttrs (old: rec {
              nativeBuildInputs = with super; [
                pkg-config
                swig
              ];

              checkPhase = "true";
            });
          };
        in
        super.python3.override { inherit packageOverrides; };
    in
    (super.whipper.override { inherit python3; }).overrideAttrs (_: rec {
      postPatch = ''
        sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
      '';
    });
}
