{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-ld.url = "github:Mic92/nix-ld/main";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dotnix.url = "git+file:///etc/nixos/external/dotnix";
    dotnix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    let
      origin = inputs.nixpkgs.legacyPackages."x86_64-linux";
      nixpkgs = origin.applyPatches {
        name = "nixpkgs-custom";
        src = inputs.nixpkgs;
        patches = [ ./patches/nvidia-open.patch ];
      };
      nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
    in {
      nixosConfigurations = {
        nixos = nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./config/per-machine/NyZen9.nix
            ./profile/NyZen9.nix

            inputs.nix-ld.nixosModules.nix-ld
            (_: {
              nixpkgs.overlays = [ inputs.dotnix.overlay (import ./pkgs) ];
            })
          ];
        };
      };
    };
}
