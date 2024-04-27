_: super:
let
  require = path: super.callPackage (import path);
in
{
  calibre =
    let
      python3 = super.python3.override {
        packageOverrides = final: prev: {
          mechanize = prev.mechanize.overrideAttrs (_: {
            dontUsePytestCheck = true;
          });
        };
      };
    in
    super.calibre.override { python3Packages = python3.pkgs; };

  weston = super.weston.override { vncSupport = false; };
  whipper = super.whipper.overrideAttrs (_: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });
}
