{ pkgs, ... }:
{
  environment.systemPackages = (
    with pkgs;
    [
      speechd-with-openjtalk
      openjtalk
      espeak
    ]
    ++ (with openjtalk; [
      hts-voice-nitech-jp-atr503-m001
      open-jtalk-mecab-naist-jdic-utf8
    ])
  );
}
