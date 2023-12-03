self: super:
let require = path: super.callPackage (import path);
in {
  xdg-desktop-portal = super.xdg-desktop-portal.overrideAttrs (old: {
    doCheck = false;
    mesonFlags = old.mesonFlags ++ [ "-Dpytest=disabled" ];
  });

  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });
}
