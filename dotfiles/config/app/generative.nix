{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rocm-shell
  ];
}
