{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.sandboxed-commands.git;
  };
}
