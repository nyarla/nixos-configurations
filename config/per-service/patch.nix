{ pkgs, ... }: {
  system.replaceRuntimeDependencies = [{
    original = pkgs.alsaLib;
    replacement = pkgs.alsaLib.overrideAttrs (old: rec {
      patches = [
        (pkgs.fetchpatch {
          url =
            "https://raw.githubusercontent.com/NixOS/nixpkgs/staging/pkgs/os-specific/linux/alsa-project/alsa-lib/alsa-plugin-conf-multilib.patch";
          sha256 = "0wj86fcvm50699gjgmcdgfh2zvv3gk25xgyyq9xb3lk9fh8gipy2";
        })
      ];
    });
  }];
}
