{ pkgs, ... }:
{
  systemd.tmpfiles.rules =
    let
      plogue = pkgs.symlinkJoin {
        name = "plogue-synth";
        paths = with pkgs.chipsynth; [
          sfc
        ];
      };
    in
    [
      "L+ /opt/Plogue - - - - ${plogue}/opt/Plogue"
    ];
}
