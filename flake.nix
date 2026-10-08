{
  description = "NixOS configurations for my PCs";
  inputs = {
    # packages
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
      };
    };

    xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        systems.follows = "systems";
        nvfetcher.follows = "nvfetcher";
        treefmt-nix.follows = "treefmt";
      };
    };

    nvfetcher = {
      url = "github:Red-M/nvfetcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";

    # modules
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # libraries
    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    flake-compat.url = "github:nix-community/flake-compat";

    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      stable,
      home-manager,
      wayland,
      impermanence,
      xr,
      ...
    }@inputs:
    rec {
      legacyPackages.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend (
        final: prev:
        prev
        // (import ./pkgs/default.nix { inherit nixpkgs; } final prev)
        // (import ./pkgs/temporary.nix { inherit nixpkgs stable; } final prev)
      );

      ## test
      nixosConfigurations =
        let
          nixosSystem =
            opts:
            (import ./lib/nixosSystem.nix {
              inherit nixpkgs;
              inherit (opts) system patches;
            })
              {
                inherit (opts)
                  hostname
                  profile
                  overlays
                  modules
                  ;
              };
        in
        {
          nixos = nixosSystem {
            hostname = "nixos";
            profile = import ./system/profile/NyZen9.nix;
            system = "x86_64-linux";
            patches = [
              (legacyPackages.x86_64-linux.fetchpatch {
                url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/562330.patch";
                sha256 = "1kj1zc9mmys4rdvz3bvvyj2fhhpzjmddm0hsgpdpdbfn4yh3v7kz";
              })
            ];
            overlays = [
              wayland.overlay
              (import ./pkgs/temporary.nix { inherit nixpkgs stable; })
              (import ./pkgs/default.nix { inherit nixpkgs; })
            ];

            modules = [
              xr.nixosModules.nixpkgs-xr
              impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              (_: {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  users.nyarla = import ./dotfiles/user/nyarla.nix;
                };
              })
            ];
          };
        };
    };
}
