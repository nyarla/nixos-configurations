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
      flake-utils,
      ...
    }@inputs:
    let
      overlay =
        final: prev:
        prev
        // (wayland.overlay final prev)
        // (import ./pkgs/default.nix { inherit nixpkgs; } final prev)
        // (import ./pkgs/temporary.nix {
          inherit nixpkgs;
          inherit stable;
        } final prev);

      flakeFor =
        system: patches:
        (import nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched-${nixpkgs.shortRev}";
          src = inputs.nixpkgs;
          inherit patches;
        };

      pkgsFor = system: flake: (import flake { inherit system; }).extend overlay;

      nixpkgsFor = system: patches: rec {
        flake = flakeFor system patches;
        legacyPackages = pkgsFor system flake;
        lib.nixosSystem =
          {
            modules ? [ ],
            ...
          }@inputs:
          import "${flake}/nixos/lib/eval-config.nix" {
            inherit system;

            baseModules = import "${flake}/nixos/modules/module-list.nix";
            specialArgs = (inputs.specialArgs or { }) // {
              modulePath = "${flake}/nixos/modules";
            };

            modules = [
              {
                nix = {
                  registry.nixpkgs = { inherit flake; };
                  settings = {
                    trusted-public-keys = [
                      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    ];

                    trusted-users = [
                      "root"
                      "@wheel"
                    ];

                    substituters = [
                      "https://cache.nixos.org"
                    ];

                    experimental-features = [
                      "nix-command"
                      "flakes"
                    ];

                    nix-path = [
                      "nixpkgs=${flake}"
                    ];
                  };
                };
              }
              (import ./modules)
            ]
            ++ modules;
          };
      };

      systemFor =
        system:
        {
          x86_64-linux = nixpkgsFor system [ ];
        }
        .${system};
    in
    flake-utils.lib.eachDefaultSystem (system: {
      inherit (systemFor system) legacyPackages;
    })
    // flake-utils.lib.eachDefaultSystemPassThrough (system: {
      nixosConfigurations.nixos = (systemFor system).lib.nixosSystem {
        modules = [
          xr.nixosModules.nixpkgs-xr
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "nixos";
            nix.settings = {
              trusted-public-keys = [
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              ];

              substituters = [
                "https://nixpkgs-wayland.cachix.org"
              ];
            };

            nixpkgs = {
              overlays = [ overlay ];
              config.allowUnfree = true;
            };
          }
          (import ./system/profile/NyZen9.nix)
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              users.nyarla = import ./dotfiles/user/nyarla.nix;
            };
          }
        ];
      };
    });
}
