{
  nixpkgs,

  lib,

  moltenvk,
  pkgs,
  pkgsCross,
  pkgsi686Linux,

  callPackage,
  buildEnv,
  writeScriptBin,

  multiStdenv,
  wineasio,

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

  wineasioRuntime = wineasio.override { wine = wineRuntime; };
  wineasio-register = writeScriptBin "wineasio-register" ''
    if [[ ! -e drive_c ]]; then
      echo 'This directory is not wine prefix' >&2; exit 1
    fi

    u32=${wineasioRuntime}/lib/wine/i386-unix/wineasio32.dll.so
    w32=$(echo $u32 | sed -e 's|/i386-unix/wineasio32.dll.so|/i386-windows/wineasio32.dll|')
    p32=drive_c/windows/system32/wineasio32.dll

    [[ ! -e $p32 ]] || chmod +w $p32
    cp $w32 $p32 && wine regsvr32 $u32

    u64=${wineasioRuntime}/lib/wine/x86_64-unix/wineasio64.dll.so
    w64=$(echo $u64 | sed -e 's|/x86_64-unix/wineasio64.dll.so|/x86_64-windows/wineasio64.dll|')
    p64=drive_c/windows/syswow64/wineasio64.dll

    [[ ! -e $p64 ]] || chmod +w $p64
    cp $w64 $p64 && wine64 regsvr32 $u64
  '';
in
buildEnv {
  name = "${pname}-runtime";
  paths = [
    wineRuntime
    wineasioRuntime
    wineasio-register
  ];

  pathsToLink = [
    "/bin"
    "/lib"
    "/include"
    "/share"
  ];
}
