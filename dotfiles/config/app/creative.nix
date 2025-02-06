{ pkgs, ... }:
{
  home.sessionVariables = {
    VST_PATH = "$HOME/.nix-profile/lib/vst:$HOME/.nix-profile/lib/lxvst";
    VST3_PATH = "$HOME/.nix-profile/lib/vst3";
    LV2_PATH = "$HOME/.nix-profile/lib/lv2";
    CLAP_PATH = "$HOME/.nix-profile/lib/clap";
  };

  home.packages =
    with pkgs;
    [
      # graphics
      gimp
      inkscape
      krita

      # pixel arts
      aseprite
      pixelorama
    ]
    ++ [
      # digital audio workstation
      bitwig-studio3
      famistudio
      helio-workstation
      musescore

      # voice synthesize
      openutau
      voicevox

      # sample manager
      sononym-bin

      # vst plugin host
      audiogridder
      carla
      ildaeil

      # vst plugins
      calf
      surge-XT

      # generator plugins
      bespokesynth-with-vst2
      bristol
      chow-kick
      dexed
      drumgizmo
      drumkv1
      helm
      hydrogen
      odin2
      sfizz
      sorcer
      tunefish
      vital

      # effect plugins
      aether-lv2
      airwindows
      artyFX
      chow-tape-model
      lsp-plugins
      zam-plugins
    ]
    ++ [
      blender
    ];
}
