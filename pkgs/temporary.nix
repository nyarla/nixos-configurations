self: super:
let require = path: super.callPackage (import path);
in {
  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });

  android-tools = super.android-tools.overrideAttrs (old: rec {
    patches = old.patches ++ [
      (super.fetchpatch {
        url =
          "https://raw.githubusercontent.com/NixOS/nixpkgs/f5db877954c6839a2de43b3e2a4f70f0836fad3b/pkgs/tools/misc/android-tools/android-tools-kernel-headers-6.0.diff";
        sha256 = "1wlxlb6p9n6ppn0ikwnl023lsdgvlhshaykj91asqa5lip1rzqyz";
      })
    ];
  });
}
