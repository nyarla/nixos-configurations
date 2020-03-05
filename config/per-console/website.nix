{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hugo sassc mecab
  ];
}
