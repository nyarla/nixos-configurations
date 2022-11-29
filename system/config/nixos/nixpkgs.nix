{ config, pkgs, ... }: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      cores = 31;
      max-jobs = 31;
    };
  };

  nixpkgs = { config.allowUnfree = true; };
}
