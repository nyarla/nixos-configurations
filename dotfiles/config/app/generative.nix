{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lmstudio
    stability-matrix
  ];
}
