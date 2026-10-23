_: {
  imports = [
    # currently migrating...
    ../../system/profile/NyZen9.nix

    # using modules.
    ../../modules/nixos/audio/pipewire.nix
    ../../modules/nixos/programs/desktop.nix
    ../../modules/nixos/programs/sandbox.nix
    ../../modules/nixos/regions/jp.nix
    ../../modules/nixos/services/desktop.nix

    # per-profile configurations
    ./hardware/audio.nix
    ./hardware/cpu.nix
    ./hardware/inputs.nix
    ./hardware/power-managements.nix
    ./i18n/region.nix
    ./programs/desktop.nix
  ];
}
