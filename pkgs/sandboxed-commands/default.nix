{ callPackage }:
{
  bun = callPackage ./bun.nix { };
  git = callPackage ./git.nix { };
  nvim = callPackage ./nvim.nix { };
  pi = callPackage ./pi.nix { };
  pi-network = callPackage ./pi-network.nix { };
}
