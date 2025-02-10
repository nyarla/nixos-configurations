{
  nixpkgs,

  lib,

  moltenvk,
  pkgs,
  pkgsCross,
  pkgsi686Linux,

  callPackage,

  multiStdenv,

  pname,
  version,
  src,
  staging,
  disabledPatchsets ? [ ],
}:

let
  path = import "${nixpkgs}/pkgs/applications/emulators/wine/base.nix";
  supportFlags = import ./supportedFlags.nix;

  defaults =
    let
      sources =
        (import "${nixpkgs}/pkgs/applications/emulators/wine/sources.nix" { inherit pkgs; }).unstable;
    in
    {
      inherit supportFlags;
      inherit moltenvk;
      patches = [
        "${nixpkgs}/pkgs/applications/emulators/wine/cert-path.patch"
      ];
      buildScript = "${nixpkgs}/pkgs/applications/emulators/wine/builder-wow.sh";
      configureFlags = [ "--disable-tests" ];
      geckos = with sources; [
        gecko32
        gecko64
      ];
      monos = with sources; [
        mono
      ];
      pkgArches = [
        pkgs
        pkgsi686Linux
      ];
      mingwGccs = with pkgsCross; [
        mingw32.buildPackages.gcc
        mingwW64.buildPackages.gcc
      ];
      platforms = [ "x86_64-linux" ];
      stdenv = multiStdenv;
      wineRelease = "unstable";
    };

  wineUnstable = callPackage path (
    defaults
    // {
      inherit pname;
      inherit version;
      inherit src;
    }
  );

  wineRuntime =
    if staging == null then
      wineUnstable
    else
      wineUnstable.overrideDerivation (self: {
        nativeBuildInputs =
          (with pkgs; [
            autoconf
            gitMinimal
            hexdump
            perl
            python3
          ])
          ++ (with pkgsi686Linux; [
            autoconf
            gitMinimal
            hexdump
            perl
            python3
          ])
          ++ self.nativeBuildInputs;

        prePatch =
          self.prePatch or ''
            patchShebangs tools
            cp -r ${staging}/patches ${staging}/staging .
            chmod +w patches
            patchShebangs patches/gitapply.sh
            python3 ./staging/patchinstall.py DESTDIR="$PWD" --all ${
              lib.concatMapStringsSep " " (ps: "-W ${ps}") disabledPatchsets
            }
          '';
      });
in
wineRuntime
