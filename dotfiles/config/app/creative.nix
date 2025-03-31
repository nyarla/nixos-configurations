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

      # plugin bridge
      yabridge
      yabridgectl

      # vst plugins
      calf
      surge-XT

      # generator plugins
      adlplug
      aeolus
      ams
      bespokesynth-with-vst2
      bjumblr
      bristol
      chow-kick
      dexed
      drumgizmo
      drumkv1
      geonkick
      helm
      hydrogen
      librearp
      ninjas2
      odin2
      opnplug
      oxefmsynth
      padthv1
      qsynth
      samplv1
      sfizz
      sorcer
      sorcer
      synthv1
      tunefish
      tunefish
      vital
      x42-avldrums
      x42-gmsynth
      yoshimi
      zynaddsubfx

      # effect plugins
      aether-lv2
      airwindows
      artyFX
      bankstown-lv2
      bchoppr
      bolliedelayxt-lv2
      boops
      bs2b-lv2
      bshapr
      bslizr
      chow-tape-model
      eq10q
      fverb
      gxplugins-lv2
      kapitonov-plugins-pack
      lsp-plugins
      lsp-plugins
      mod-distortion
      molot-lite
      mooSpace
      neural-amp-modeler-lv2
      noise-repellent
      rkrlv2
      talentedhack
      tap-plugins
      vocproc
      x42-plugins
      zam-plugins
      calf

      # others
      bschaffl
      bsequencer
      calf
      fomp
      mda_lv2
      midi-trigger
      mod-arpeggiator-lv2
      plujain-ramp
      vcv-rack

      # assets
      aeolus-stops
      freepats
    ]
    ++ [
      blender
    ];
}
