{ pkgs, ... }: {
  # wireless
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=JP
  '';

  # timezone
  time.timeZone = "Asia/Tokyo";

  services.timesyncd.enable = true;
  networking.timeServers =
    [ "ntp1.jst.mfeed.ad.jp" "ntp2.jst.mfeed.ad.jp" "ntp3.jst.mfeed.ad.jp" ];

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
}
