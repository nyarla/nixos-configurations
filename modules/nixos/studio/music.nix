{ pkgs, ... }: {
  environment.systemPackages =
    with pkgs;
    [
      # plugin host
      carla
      ildaeil

      # sample manager
      sononym-bin

      # audio recorder
      audacity

      # DAW
      bitwig-studio6
      musescore

      # plugins
      dexed
      helm
      odin2
      surge
      vital

      # for Windows plugins
      # yabridge
      # yabridgectl
    ]
    ++ (with chipsynth; [ sfc ]);

  systemd.tmpfiles.rules =
    let
      plogue = pkgs.symlinkJoin {
        name = "plogue-synthesizers";
        paths = with pkgs.chipsynth; [
          sfc
        ];
      };
    in
    [
      "L+ /opt/Plogue - - - - ${plogue}/opt/Plogue"
    ];
}
