{ config, pkgs, ... }:
{
  virtualisation.anbox = {
    enable = true;
    ipv4   = {
      container = {
        address = "10.20.30.2";
        prefixLength = 24;
      };
      gateway = {
        address = "10.20.30.1";
        prefixLength = 24;
      };
      dns = "1.1.1.1";
    };
  };

  nixpkgs.config.packageOverrides = super: {
    anbox = super.anbox.overrideAttrs (old: rec {
      pname   = "anbox";
      version = "2019-01-24";
      name    = "${pname}-${version}";

      src     = super.fetchFromGitHub rec {
        owner   = pname;
        repo    = pname;
        rev     = "bb97f3ac4a7bbbe3a08f7a87a5dbf211542bc133";
        sha256  = "1mij6i8km3fiamva4hxgcsihiifm83hhdcws8ws4mfs5sbs96qw8";
      };

      patchPhase = old.patchPhase + ''
        sed -i "s|return DensityType::medium;|return DensityType::high;|" src/anbox/graphics/density.cpp
      '';
    });
  }; 
}
