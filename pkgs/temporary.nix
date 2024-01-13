self: super:
let require = path: super.callPackage (import path);
in {
  whipper = super.whipper.overrideAttrs (old: rec {
    postPatch = ''
      sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });

  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (_: prev: rec {
      pyopenssl = prev.pyopenssl.overridePythonAttrs (_: rec {
        version = "23.2.0";

        src = prev.fetchPypi {
          pname = "pyOpenSSL";
          inherit version;
          hash = "sha256-J2+TH1WkUufeppxxc+mE6ypEB85BPJGKo0tV+C+bi6w=";
        };
      });
    })
  ];
}
