{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (final: parent: rec {
      buildPackages_1_6_2 = parent.buildPackages.overrideScope'
        (super: self: rec {
          nim-unwrapped = super.nim-unwrapped.overrideAttrs (old: rec {
            version = "1.6.2";
            src = super.fetchurl {
              url = "https://nim-lang.org/download/nim-${version}.tar.xz";
              hash = "sha256-msRxT6bDFdaR2n9diUHBsZDU1Dc5fZdC4yfC1RiT43M=";
            };
          });
        });
      nimPackages_1_6_2 = parent.nimPackages.overrideScope'
        (super: self: rec { buildPackages = final.buildPackages_1_6_2; });
      nitter =
        parent.nitter.override { nimPackages = final.nimPackages_1_6_2; };
    })
  ];
}
