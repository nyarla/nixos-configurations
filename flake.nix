{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-ld.url = "github:Mic92/nix-ld/main";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dotnix.url = "git+file:///etc/nixos/external/dotnix";
    dotnix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nix-ld, home-manager, dotnix, ... }@inputs: {
    nixosConfigurations = let
      applyPatch = args:
        inputs.nixpkgs.legacyPackages.${args.system}.applyPatches {
          inherit (args) name patches;
          src = inputs.nixpkgs;
        };
    in {
      # NyZen9
      nixos = let
        name = "nixpkgs-custom-NyZen9";
        system = "x86_64-linux";
        patches = [ ./patches/nvidia-open.patch ];
        nixpkgs = applyPatch { inherit name system patches; };
        nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
      in nixosSystem {
        inherit system;
        modules = [
          ./system/profile/NyZen9.nix
          ./profile/NyZen9.nix

          nix-ld.nixosModules.nix-ld
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyarla = import ./dotfiles/user/nyarla.nix;
          }

          (_: {
            nixpkgs.overlays = [ dotnix.overlay (import ./pkgs) ];
            system.stateVersion =
              (import ./system/config/nixos/version.nix).stateVersion;
          })
        ];
      };
    };
  };
}
