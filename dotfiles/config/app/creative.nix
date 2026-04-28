{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # for edit graphics
    gimp3
    inkscape
    krita

    # for pixel arts
    aseprite
    pixelorama

    # for 3D modeling
    alcom
    pkgsRocm.blender

    # for music creation
    helio-workstation
    ildaeil

    chipsynth.sfc

    yabridge
    yabridgectl
  ];

  home.sessionVariables = {
    CLAP_PATH = "$HOME/.local/state/nix/profiles/profile/lib/clap";
    LV2_PATH = "$HOME/.local/state/nix/profiles/profile/lib/lv2";
    VST3_PATH = "$HOME/.local/state/nix/profiles/profile/lib/vst3";
    VST_PATH = "$HOME/.local/state/nix/profiles/profile/lib/vst";
  };
}
