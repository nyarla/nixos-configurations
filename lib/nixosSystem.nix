let
  nixosSystem =
    {
      nixpkgs,
      system,
      patches,
    }:
    let
      applyPatch =
        patches:
        nixpkgs.legacyPackages.${system}.applyPatches {
          name = "nixpkgs-patched-${nixpkgs.shortRev}";
          src = nixpkgs;
          inherit patches;
        };

      flake = applyPatch patches;
    in
    {
      hostname,
      profile,
      overlays,
      modules,
    }:
    import "${flake}/nixos/lib/eval-config.nix" {
      inherit system;
      specialArgs = {
        modulesPath = toString (flake + "/nixos/modules");
      };
      baseModules = import (flake + "/nixos/modules/module-list.nix");

      modules = modules ++ [
        (
          { pkgs, ... }:
          {

            # hostname
            networking.hostName = hostname;

            # nix
            nix = {
              # workaround for devenv 1.0.8
              package = pkgs.nixVersions.nix_2_23;
              registry = {
                nixpkgs = {
                  inherit flake;
                };
              };
              settings = {
                trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                ];
                substituters = [
                  "https://cache.nixos.org"
                  "https://nixpkgs-wayland.cachix.org"
                ];
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };

              nixPath = [ "nixpkgs=${flake}" ];
            };

            nixpkgs = {
              inherit overlays;
              config = {
                allowUnfree = true;
              };
            };

            systemd.tmpfiles.rules = [ "L+ /etc/nixpkgs - - - - ${flake}" ];
          }
        )

        profile
      ];
    };
in
nixosSystem
