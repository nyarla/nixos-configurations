{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wayland.url = "github:nix-community/nixpkgs-wayland";
    wayland.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      wayland,
      impermanence,
      ...
    }:
    {
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

            patches = [ ./patches/wine-staging.patch ];
            overlays = [
              wayland.overlay
              (import ./pkgs/default.nix)
              (import ./pkgs/temporary.nix)
            ];

            modules = [
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
