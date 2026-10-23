{ lib, config, ... }:
with lib;
let
  inJapan = config.mod.regions.jp;
in
{
  options.mod.regions.jp = mkEnableOption "Set region to Japan";

  config = mkIf inJapan {
    # timezone
    time.timeZone = "Asia/Tokyo";

    # ntp
    services.timesyncd = {
      enable = true;
      servers = [
        "ntp1.jst.mfeed.ad.jp"
        "ntp2.jst.mfeed.ad.jp"
        "ntp3.jst.mfeed.ad.jp"
      ];
    };

    # radio for Wi-Fi
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom=JP
    '';
  };
}
