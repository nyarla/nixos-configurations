{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stability-matrix
  ];
}
