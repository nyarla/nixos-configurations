_: super:
let
  require = path: super.callPackage (import path);
in
{
  weston = super.weston.override { vncSupport = false; };
  whipper = super.whipper.overrideAttrs (_: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });
}
