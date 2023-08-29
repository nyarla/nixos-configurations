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
  outputs = { home-manager, wayland, impermanence, ... }@inputs: {
    nixosConfigurations = let
      applyPatch = args:
        inputs.nixpkgs.legacyPackages.${args.system}.applyPatches {
          inherit (args) name patches;
          src = inputs.nixpkgs;
        };

      nixpkgs = { system, patches, ... }:
        applyPatch {
          name = "nixpkgs-custom-${system}";
          inherit system;
          inherit patches;
        };

      nixosSystem = { arch, patches, ... }:
        config:
        let
          system = "${arch}-linux";
          pkgs = nixpkgs { inherit system patches; };
        in (import "${pkgs}/nixos/lib/eval-config.nix")
        ((config pkgs) // { inherit system; });
    in { # NyZen9
      nixos = nixosSystem {
        arch = "x86_64";
        patches = [ ];
      } (pkg: {
        modules = [
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyarla = import ./dotfiles/user/nyarla.nix;
          }

          (_: {
            nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            systemd.tmpfiles.rules = [ "L+ /etc/nixpkgs - - - - ${pkg}" ];
            nixpkgs.overlays =
              [ (import ./pkgs) (import ./pkgs/temporary.nix) wayland.overlay ];
          })

          ./system/profile/NyZen9.nix
        ];
      });
    };
  };
}
