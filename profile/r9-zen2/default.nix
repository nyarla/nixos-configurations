_: {
  imports = [
    # currently migrating...
    ../../system/profile/NyZen9.nix

    # using modules.
    ../../modules/nixos/audio/pipewire.nix
    ../../modules/nixos/regions/jp.nix

    # per-profile configurations
    ./hardware/audio.nix
    ./hardware/cpu.nix
    ./i18n/region.nix
  ];
}
