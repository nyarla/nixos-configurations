_: {
  imports = [
    # currently migrating...
    ../../system/profile/NyZen9.nix

    # using modules
    ../../modules/nixos/audio/pipewire.nix
    ../../modules/nixos/programs/desktop.nix
    ../../modules/nixos/programs/droidcam.nix
    ../../modules/nixos/programs/sandbox.nix
    ../../modules/nixos/regions/jp.nix
    ../../modules/nixos/security/clamav.nix
    ../../modules/nixos/security/sandbox.nix
    ../../modules/nixos/services/desktop.nix
    ../../modules/nixos/wireless/bluetooth.nix

    ../../modules/nixos/sandbox/desktop/deadbeef.nix

    ../../modules/nixos/sandbox/shell/typescript.nix

    ../../modules/nixos/studio/3DCG.nix
    ../../modules/nixos/studio/artwork.nix
    ../../modules/nixos/studio/music.nix

    # per-profile configurations
    ./hardware/audio.nix
    ./hardware/camera.nix
    ./hardware/cpu.nix
    ./hardware/inputs.nix
    ./hardware/power-managements.nix
    ./hardware/wireless.nix
    ./i18n/region.nix
    ./programs/desktop.nix
    ./programs/sandbox.nix
    ./programs/shell.nix
    ./security/clamav.nix
  ];
}
