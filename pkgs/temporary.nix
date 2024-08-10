_: super:
let
  require = path: super.callPackage (import path);
in
{
  devenv =
    let
      inherit (super) cachix;
      devenv_nix = super.nixVersions.nix_2_21.overrideAttrs (old: {
        version = "2.21-devenv";
        src = super.fetchFromGitHub {
          owner = "domenkozar";
          repo = "nix";
          rev = "31b9700169d9bba693c379d59d587cd20bf115a6";
          hash = "sha256-aUqR+pxqKTKLtj8HAI5sbdT6C1VgtHDcrKjmn+wWkXQ=";
        };
        buildInputs = old.buildInputs ++ [ super.libgit2 ];
        patches = old.patches ++ [ ../patches/fix-nix-2_21-devenv.patch ];
        doCheck = false;
        doInstallCheck = false;
      });
    in
    super.devenv.overrideAttrs (_: {
      postInstall = ''
        wrapProgram $out/bin/devenv --set DEVENV_NIX ${devenv_nix} --prefix PATH ":" "$out/bin:${cachix}/bin"
      '';
    });

  whipper =
    let
      python3 =
        let
          packageOverrides = final: prev: {
            pycdio = prev.pycdio.overridePythonAttrs (old: rec {
              nativeBuildInputs = with super; [
                pkg-config
                swig
              ];

              checkPhase = "true";
            });
          };
        in
        super.python3.override { inherit packageOverrides; };
    in
    (super.whipper.override { inherit python3; }).overrideAttrs (_: rec {
      postPatch = ''
        sed -i 's|cd-paranoia|${super.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
      '';
    });
}
