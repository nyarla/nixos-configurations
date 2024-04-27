{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ whipper ];
}
