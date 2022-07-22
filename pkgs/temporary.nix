self: super:
let require = path: super.callPackage (import path);
in {
  quodlibet =
    super.quodlibet.overrideAttrs (_: rec { doInstallCheck = false; });

  cnijfilter2 = super.cnijfilter2.overrideAttrs
    (old: rec { NIX_CFLAGS_COMPILE = " -fcommon"; });

  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });
}
