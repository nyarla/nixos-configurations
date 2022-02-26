{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (self: super: rec {
      nitter = super.nitter.overrideAttrs (old: rec {
        src = super.fetchFromGitHub {
          owner = "zedeus";
          repo = "nitter";
          rev = "ecb6fe4162142f7260b36d4ac4021d6ac7cd2b49";
          sha256 = "12rd5zhxzrzxgd5zg5kwkdqzzd48g840kf8x55x2a66a3afy6h87";
        };
      });
    })
  ];
}
