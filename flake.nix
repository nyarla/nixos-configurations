{
  description = "NixOS configurations for my PCs";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    wayland.url =
      "github:nix-community/nixpkgs-wayland/e903d71039c1b341b5732c402f29358f5418948c";
    wayland.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld/main";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dotnix.url = "git+file:///etc/nixos/external/dotnix";
    dotnix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/per-machine/NyZen9.nix
          ./profile/NyZen9.nix

          inputs.nix-ld.nixosModules.nix-ld
          ({ ... }: {
            environment.systemPackages =
              [ inputs.home-manager.defaultPackage."x86_64-linux" ];
            nixpkgs.overlays = [
              inputs.dotnix.overlay
              inputs.wayland.overlay
              (self: super:
                let
                  wayland-1_20_0 = super.wayland.overrideAttrs (old: rec {
                    pname = "wayland";
                    version = "1.20.0";
                    src = super.fetchurl {
                      url =
                        "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
                      sha256 =
                        "09c7rpbwavjg4y16mrfa57gk5ix6rnzpvlnv1wp7fnbh9hak985q";
                    };

                    patches = [ (builtins.elemAt old.patches 1) ];
                  });
                in {
                  wlroots = (super.wlroots.override {
                    wayland = wayland-1_20_0;
                  }).overrideAttrs (old: rec {
                    postPatch = ''
                      sed -i 's/assert(argb8888 &&/assert(true || argb8888 ||/g' 'render/wlr_renderer.c'
                    '';
                  });

                  labwc = (super.labwc.override {
                    wayland = wayland-1_20_0;
                    meson = super.meson_0_60;
                  }).overrideAttrs (old: rec {
                    src = super.fetchFromGitHub {
                      owner = "labwc";
                      repo = "labwc";
                      rev = "fd7f06a375a539df9e8bac389afa44a084b33164";
                      sha256 =
                        "sha256-MYQiC3f4TDR7F2w5vZhVlnUAV3WCCb54evQLdfA169I=";
                    };

                    postPatch = ''
                      sed -i "s!'-DWLR_USE_UNSTABLE',!'-DWLR_USE_UNSTABLE','-D_POSIX_C_SOURCE=200809L',!" meson.build
                    '';
                  });
                })
            ];
          })
        ];
      };
    };
  };
}
