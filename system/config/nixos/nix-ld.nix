{ pkgs, lib, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    cudaPackages.cudatoolkit
    stdenv.cc.cc.lib
    stdenv.cc.libc
  ];
}
