self: super:
let require = path: super.callPackage (import path);
in {
  cmake-3_28_3 = super.cmake.overrideAttrs (old: rec {
    inherit (old) pname;
    version = "3.28.3";
    src = super.fetchurl {
      url = "https://cmake.org/files/v${
          super.lib.versions.majorMinor version
        }/cmake-${version}.tar.gz";
      hash = "sha256-crdXDlyFk95qxKtDO3PqsYxfsyiIBGDIbOMmCBQa1cE=";
    };
  });

  musescore = super.musescore.override { cmake = self.cmake-3_28_3; };

  weston = super.weston.override { vncSupport = false; };

  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });
}
