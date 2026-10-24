{
  description = "NixOS configurations for my PCs";
  inputs = {
    flake-compat.url = "github:nix-community/flake-compat";

    flake-input-patcher = {
      url = "github:jfly/flake-input-patcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs = {
        nixpkgs-lib.follows = "nixpkgs";
      };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        systems.follows = "systems";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs-lib.follows = "nixpkgs";
      };
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/master";
    };

    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };

    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nvfetcher.follows = "nvfetcher";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt";
      };
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs = {
        flake-compat.follows = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nvfetcher = {
      url = "github:Red-M/nvfetcher";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    systems = {
      url = "github:nix-systems/default";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs =
    unpatchedInputs:
    let
      patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;
      #fetchpatch = patcher.fetchpatch;
      inputs = patcher.patch {
        inherit unpatchedInputs;
        flakePath = ./.;
        patchSpec = { };
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { inputs, withSystem, ... }:
      let
        overlays =
          (with inputs; [
            nixpkgs-wayland.overlay
          ])
          ++ (
            let
              inherit (inputs) nixpkgs;
              stable = inputs.nixpkgs-stable;
            in
            [
              (import ./pkgs/default.nix { inherit nixpkgs stable; })
              (import ./pkgs/temporary.nix { inherit nixpkgs stable; })
            ]
          );
      in
      {
        systems = [ "x86_64-linux" ];

        perSystem =
          { system, ... }:
          let
            pkgs = import inputs.nixpkgs {
              inherit overlays system;
            };
          in
          {
            packages = {
              inherit (pkgs)
                sources

                amd-run
                gimp-shell
                nvim-run
                perl-shel
                restic-run
                rocm-shell
                sandboxed-comands
                shellbox
                unityhub-amd

                audiogridder-modded
                deadbeef-fb
                galendae
                gyazo-diy
                ibis-office
                igsc
                immersed
                thorium-reader
                wcwidth-cjk

                fluent-gtk-theme
                fluent-kde
                kaunas
                noto-fonts-jp

                glibc-locales-eaw
                xembed-sni-proxy

                tmux

                firefox-bin-unwapped
                thunderbird-bin-unwrapped

                steam

                proton-rtsp-wayland-ge-bin

                cskk
                skk-dicts-xl

                fcitx5-fbterm
                fcitx5-cskk
                fcitx5-cskk-qt5
                fcitx5-cskk-qt6

                chipsynth
                sononym-bin

                carla-with-wine
                ildaeil

                wine-vst-run
                wine-stating-run
                wineasio

                bookwall
                comfyui
                llama-cpp-llm-jp

                vital
                ;

              inherit (pkgs.artcraft)
                cadcraft
                deckcraft
                designcraft
                effectcraft
                figcraft
                filmcraft
                gridcraft
                lightcraft
                photocraft
                soundcraft
                vectorcraft
                wordcraft
                ;

            };
          };

        flake = {
          nixosConfigurations.nixos = withSystem "x86_64-linux" (
            { ... }:
            inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                {
                  nix = {
                    registry.nixpkgs.flake = inputs.nixpkgs;

                    settings = {
                      trusted-public-keys = [
                        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                      ];

                      trusted-users = [
                        "root"
                        "@wheel"
                      ];

                      substituters = [
                        "https://cache.nixos.org"
                        "https://nixpkgs-wayland.cachix.org"
                      ];

                      experimental-features = [
                        "nix-command"
                        "flakes"
                      ];

                      nix-path = [
                        "nixpkgs=${inputs.nixpkgs}"
                      ];
                    };
                  };

                  nixpkgs = {
                    inherit overlays;
                    config.allowUnfree = true;
                  };

                  systemd.tmpfiles.rules = [
                    "L+ /etc/nixpkgs - - - - ${inputs.nixpkgs}"
                  ];
                }

                (import ./modules/nixos)
              ]
              ++ (with inputs; [
                nixpkgs-xr.nixosModules.nixpkgs-xr
                impermanence.nixosModules.impermanence
                home-manager.nixosModules.home-manager
              ])
              ++ [
                {
                  networking.hostName = "nixos";
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = false;
                    users.nyarla = import ./dotfiles/user/nyarla.nix;
                  };
                }
                (import ./profile/r9-zen2)
              ];
            }
          );
        };
      }
    );
}
