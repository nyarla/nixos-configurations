{ config, pkgs, ... }:
let apps = with pkgs; [ whipper ];
in {
  environment.systemPackages = with pkgs; apps;
}
