{ config, pkgs, lib, ... }: {
  imports = [ ../../external/nix-ld/modules/nix-ld.nix ];

  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath config.environment.systemPackages;
    NIX_LD = builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };
}
