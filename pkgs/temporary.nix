_: super:
let
  require = path: super.callPackage (import path);
in
{
  dqlite = super.dqlite.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ super.lz4.dev ];
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
