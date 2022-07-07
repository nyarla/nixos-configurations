{ pkgs, lib, ... }: {
  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath
      (with pkgs; [ cudaPackages.cudatoolkit stdenv.cc.cc.lib stdenv.cc.libc ]);
  };

  environment.etc."profile.d/nix-ld.sh" = {
    text = ''
      export NIX_LD=$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)
    '';
  };
}
