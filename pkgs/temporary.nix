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

  pam_u2f = super.pam_u2f.override {
    libfido2 = super.libfido2.override {
      pcsclite = super.pcsclite.overrideAttrs (old: {
        postPatch =
          old.postPatch
          + ''
            substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
              --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
          '';
      });
    };
  };
}
