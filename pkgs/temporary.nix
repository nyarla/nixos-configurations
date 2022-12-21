self: super:
let require = path: super.callPackage (import path);
in {
  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });

  weston = super.weston.overrideAttrs
    (old: rec { buildInputs = old.buildInputs ++ (with super; [ freerdp ]); });
}
