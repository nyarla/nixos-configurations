{ lib, config, ... }:
with lib;
let
  enabled = config.my.location.jp;
in
{
  options.my.location.jp = mkEnableOption "Enable settings for Japan";

  config = mkIf enabled {
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
