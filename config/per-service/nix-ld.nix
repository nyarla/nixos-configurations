{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ zlib ];
  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath config.environment.systemPackages;
    NIX_LD = "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };
  environment.etc."profile.d/nix-ld" = {
    text = ''
      export NIX_LD_LIBRARY_PATH="${
        lib.makeLibraryPath config.environment.systemPackages
      }"
      export NIX_LD="$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"
    '';
  };
}
