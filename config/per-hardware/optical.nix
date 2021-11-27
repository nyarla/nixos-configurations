{ config, pkgs, ... }:
let apps = with pkgs; [ whipper cdparanoia ];
in { environment.systemPackages = with pkgs; apps; }
