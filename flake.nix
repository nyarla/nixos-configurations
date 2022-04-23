{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-ld.url = "github:Mic92/nix-ld/main";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dotnix.url = "git+file:///etc/nixos/external/dotnix";
    dotnix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/per-machine/NyZen9.nix
          ./profile/NyZen9.nix

          inputs.nix-ld.nixosModules.nix-ld
          (_: { nixpkgs.overlays = [ inputs.dotnix.overlay (import ./pkgs) ]; })
        ];
      };
    };
  };
}
