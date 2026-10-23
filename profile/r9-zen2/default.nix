_: {
  imports = [
    # currently migrating...
    ../../system/profile/NyZen9.nix

    # using modules.
    ../../modules/nixos/audio/pipewire.nix

    # per-profile configurations
    ./hardware/audio.nix
    ./hardware/cpu.nix
  ];
}
