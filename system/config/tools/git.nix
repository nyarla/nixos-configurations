{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.fence-sandboxed;
  };
}
