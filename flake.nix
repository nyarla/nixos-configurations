{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wayland.url = "github:nix-community/nixpkgs-wayland";
    wayland.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { home-manager, wayland, ... }@inputs: {
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
    in {
      # nixos custom recovery
      nixos-recovery = nixosSystem {
        arch = "x86_64";
        patches = [ ./patches/qgnomeplatform-qt6.patch ];
      } (pkg: {
        modules = [
          "${pkg}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
          ./system/profile/Recovery.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = import ./dotfiles/user/nixos.nix;
          }

          (_: {
            nix.nixPath = [
              "nixpkgs=${pkg}"
              "nixos-config=/etc/nixos/configuration.nix"
              "/nix/var/nix/profiles/per-user/root/channels"
            ];
            nixpkgs.overlays =
              [ (import ./pkgs) (import ./pkgs/temporary.nix) ];
            system.stateVersion =
              (import ./system/config/nixos/version.nix).stateVersion;
          })
        ];
      });

      # NyZen9
      nixos = nixosSystem {
        arch = "x86_64";
        patches = [ ./patches/qgnomeplatform-qt6.patch ];
      } (pkg: {
        modules = [
          ./system/profile/NyZen9.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nyarla = import ./dotfiles/user/nyarla.nix;
          }

          (_: {
            nix.nixPath = [
              "nixpkgs=${pkg}"
              "nixos-config=/etc/nixos/configuration.nix"
              "/nix/var/nix/profiles/per-user/root/channels"
            ];
            nixpkgs.overlays =
              [ (import ./pkgs) (import ./pkgs/temporary.nix) wayland.overlay ];
            system.stateVersion =
              (import ./system/config/nixos/version.nix).stateVersion;
          })
        ];
      });
    };
  };
}
