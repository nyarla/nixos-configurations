{ pkgs, ... }:
{
  home.sessionVariables =
    let
      user = "$HOME/.nix-profile";
      sys = "/run/current-system/sw";
      mkPath = plugin: "$HOME/.${plugin}:${user}/lib/${plugin}:${sys}/lib/${plugin}";
    in
    {
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
    famistudio
    helio-workstation
    musescore

    # samples manager
    sononym-bin

    # utility
    a2jmidid
    audiogridder
    carla
    ildaeil

    # wine
    wineasio
    yabridge
    yabridgectl
    jackass

    # instruments
    adlplug
    aeolus
    aeolus-stops
    ams
    ams-lv2
    bespokesynth-with-vst2
    bjumblr
    bristol
    chow-kick
    dexed
    drumgizmo
    drumkv1
    fmsynth
    geonkick
    gnaural
    helm
    hydrogen
    industrializer
    librearp-lv2
    ninjas2
    odin2
    opnplug
    oxefmsynth
    padthv1
    qsynth
    samplv1
    sfizz
    sorcer
    surge
    surge-XT
    synthv1
    tunefish
    tunfish
    vital
    x42-avldrums
    x42-gmsynth
    yoshimi
    zynaddsubfx

    # effects
    aether-lv2
    airwindows
    artyFX
    autotalent
    bankstown-lv2
    bchoppr
    bolliedelayxt-lv2
    boops
    bs2b-lv2
    bshapr
    bslizr
    caps
    chow-tape-model
    eq10q
    fverb
    gxmatcheq-lv2
    gxpluginsl-lv2
    infamousePlugins
    kapitonov-plugins-pack
    lsp-plugins
    mod-distortion
    molot-lite
    mooSpace
    neural-amp-modeler-lv2
    noise-repellent
    nova-filters
    rkrlv2
    talentedhack
    tap-plugins
    vocproc
    x42-plugins
    zam-plugins

    # plugin
    AMB-plugins
    bschaffl
    bsequencer
    calf
    fomp
    mda_lv2
    metersLv2
    midi-trigger
    mod-arpeggiator-lv2
    plujain-ramp
    vcv-rack

    # assets
    freepats
  ];
}
