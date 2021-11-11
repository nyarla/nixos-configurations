{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-ld.url = "github:Mic92/nix-ld/main";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dotnix.url = "git+file:///etc/nixos/external/dotnix";
    dotnix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nix-ld, dotnix, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/per-machine/NyZen9.nix
          ./profile/NyZen9.nix

          nix-ld.nixosModules.nix-ld
          ({ ... }: { nixpkgs.overlays = [ dotnix.overlay ]; })
        ];
      };
    };
  };
}
