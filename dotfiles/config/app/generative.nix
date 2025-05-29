{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lmstudio
  ];
}
