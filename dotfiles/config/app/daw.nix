{ pkgs, lib, ... }: {
  home.sessionVariables =
    let prefix = "/run/current-system/etc/profiles/per-user/nyarla";
    in {
      CLAP_PATH = "~/.clap:${prefix}/lib/clap";
      DSSI_PATH = "~/.dssi";
      LADSPA_PATH = "~/.ladspa";
      LV2_PATH = "~/.lv2:${prefix}/lv2";
      VST3_PATH = "~/.vst3:${prefix}/lib/vst3";
      VST_PATH = "~/.vst:${prefix}/lib/vst:${prefix}/lxvst";
    };
  home.packages = with pkgs; [
    # digital audio workstation
    bitwig-studio3
    musescore
    zrythm

    # samples manager
    sononym-bin

    # utility
    a2jmidid
    audiogridder
    carla

    # plugins
    ChowKick
    adlplug
    aeolus
    ams
    bespokesynth
    bristol
    calf
    dexed
    drumgizmo
    drumkv1
    fluidsynth
    fmsynth
    freepats
    geonkick
    gnaural
    helm
    hydrogen
    ildaeil
    industrializer
    linuxsampler
    opnplug
    oxefmsynth
    padthv1
    qsynth
    samplv1
    sorcer
    sunvox
    surge
    surge-XT
    synthv1
    vcv-rack
    x42-avldrums
    x42-gmsynth
    yoshimi
    zyn-fusion
  ];
}
