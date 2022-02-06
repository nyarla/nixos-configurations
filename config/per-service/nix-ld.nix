{ config, pkgs, lib, ... }: {
  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      stdenv.cc.cc.lib
      stdenv.cc.libc

      gtk2
    ]);
    NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  };
}
