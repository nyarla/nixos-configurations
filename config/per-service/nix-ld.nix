{ config, pkgs, lib, ... }: {
  environment.variables = {
    NIX_LD_LIBRARY_PATH =
      lib.makeLibraryPath (with pkgs; [ cudaPackages.cudatoolkit ]);
  };

  environment.etc."profile.d/nix-ld" = {
    text = ''
      export NIX_LD=$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)
    '';
  };
}
