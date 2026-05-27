{ callPackage }:
{
  git = callPackage ./git.nix { };
  nvim = callPackage ./nvim.nix { };
}
