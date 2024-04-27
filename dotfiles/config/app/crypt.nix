{ pkgs, ... }:
{
  home.packages = with pkgs; [
    electrum
    electrum-ltc
  ];
}
