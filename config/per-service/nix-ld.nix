{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ zlib stdenv.cc stdenv.cc.cc.lib ];
  environment.etc."profile.d/nix-ld" = {
    text = ''
      export NIX_LD_LIBRARY_PATH="${
        lib.makeLibraryPath config.environment.systemPackages
      }"

      export NIX_LD_LIBRARY_PATH=$( echo $NIX_LD_LIBRARY_PATH | tr ':' "\n" | sort | uniq | tr "\n" ":" | sed 's/:$//' )
      export NIX_LD="$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"
    '';
  };
}
