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

  nvidia-vaapi-driver = super.nvidia-vaapi-driver.overrideAttrs (old: rec {
    version = "0.0.8";
    src = super.fetchFromGitHub {
      owner = "elFarto";
      repo = old.pname;
      rev = "v${version}";
      sha256 = "sha256-RMFkClaWoFNeSglV5otS/rzI6JNQMiAHDzH3DoEHA5I=";
    };
  });
}
