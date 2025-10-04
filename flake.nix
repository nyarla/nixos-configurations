{
  description = "NixOS configurations for my PCs";
  inputs = {
    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    flake-compat.url = "github:nix-community/flake-compat";

    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    lib-aggregate.url = "github:nix-community/lib-aggregate";
    lib-aggregate.inputs.flake-utils.follows = "flake-utils";
    lib-aggregate.inputs.nixpkgs-lib.follows = "nixpkgs-lib";

    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wayland.url = "github:nix-community/nixpkgs-wayland";
    wayland.inputs.nixpkgs.follows = "nixpkgs";
    wayland.inputs.flake-compat.follows = "flake-compat";
    wayland.inputs.lib-aggregate.follows = "lib-aggregate";

    impermanence.url = "github:nix-community/impermanence";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-xr.inputs.flake-compat.follows = "flake-compat";
    nixpkgs-xr.inputs.flake-utils.follows = "flake-utils";
    nixpkgs-xr.inputs.systems.follows = "systems";

    waybar.url = "github:Alexays/Waybar";
    waybar.inputs.nixpkgs.follows = "nixpkgs";
    waybar.inputs.flake-compat.follows = "flake-compat";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      wayland,
      impermanence,
      nixpkgs-xr,
      waybar,
      ...
    }:
    {
      legacyPackages.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend (
        final: prev:
        prev
        // (import ./pkgs/default.nix { inherit nixpkgs; } final prev)
        // (import ./pkgs/temporary.nix { inherit nixpkgs; } final prev)
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
            patches = [ ];
            overlays = [
              wayland.overlay
              waybar.overlays.default
              (import ./pkgs/temporary.nix { inherit nixpkgs; })
              (import ./pkgs/default.nix { inherit nixpkgs; })
            ];

            modules = [
              nixpkgs-xr.nixosModules.nixpkgs-xr
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
