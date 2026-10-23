_: {
  imports = [
    # currently migrating...
    ../../system/profile/NyZen9.nix

    # using modules.
    ../../modules/nixos/audio/pipewire.nix

    # per-profile configurations
    ./audio.nix
    ./cpu.nix
  ];
}
