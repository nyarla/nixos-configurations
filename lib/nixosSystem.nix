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
              package = pkgs.nixUnstable;
              registry = {
                nixpkgs = {
                  inherit flake;
                };
              };
              settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
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
