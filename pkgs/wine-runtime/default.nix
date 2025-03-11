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
      echo 'This directory is not wine prefix!' >&2; exit 1
    fi

    case "''${1:-}" in
      32)
        [[ ! -e drive_c/windows/system32/wineasio32.dll ]] || chmod +w drive_c/windows/system32/wineasio32.dll
        cp ${wineasioRuntime}/lib/wine/i386-unix/wineasio32.dll.so \
          drive_c/windows/system32/wineasio32.dll
        wine regsvr32 wineasio32.dll
        ;;

      64)
        [[ ! -e drive_c/windows/system32/wineasio64.dll ]] || chmod +w drive_c/windows/system32/wineasio64.dll

        cp ${wineasioRuntime}/lib/wine/x86_64-unix/wineasio64.dll.so \
          drive_c/windows/system32/wineasio64.dll

        wine64 regsvr32 wineasio64.dll
        ;;

      wow)
        [[ ! -e drive_c/windows/system32/wineasio32.dll ]] || chmod +w drive_c/winsows/syswow64/wineasio32.dll
        cp ${wineasioRuntime}/lib/wine/i386-unix/wineasio32.dll.so \
          drive_c/windows/syswow64/wineasio32.dll
        wine regsvr32 wineasio32.dll
        ;;

      *)
        echo "Usage: wineasio-register [32|64|wow]";
        exit 0;
        ;;
    esac
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
