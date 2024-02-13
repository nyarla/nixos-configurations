{ pkgs, ... }: {
  home.sessionVariables = let
    user = "$HOME/.nix-profile";
    sys = "/run/current-system/sw";
    mkPath = plugin:
      "$HOME/.${plugin}:${user}/lib/${plugin}:${sys}/lib/${plugin}";
  in {
    CLAP_PATH = mkPath "clap";
    DSSI_PATH = mkPath "dssi";
    LADSPA_PATH = mkPath "ladspa";
    LV2_PATH = mkPath "lv2";
    VST3_PATH = (mkPath "vst3") + ":" + (mkPath "lxvst3");
    VST_PATH = (mkPath "vst") + ":" + (mkPath "lxvst");
  };
  home.packages = with pkgs; [
    # jackd
    qjackctl
    jack2Full

    # digital audio workstation
    bitwig-studio3
    musescore
    helio-workstation

    # samples manager
    sononym-bin

    # utility
    a2jmidid
    audiogridder
    carla

    # wine
    yabridge
    yabridgectl

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
