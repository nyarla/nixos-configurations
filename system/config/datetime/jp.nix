_: {
  # timezone
  time.timeZone = "Asia/Tokyo";

  # ntp sync
  services.timesyncd.enable = true;
  networking.timeServers =
    [ "ntp1.jst.mfeed.ad.jp" "ntp2.jst.mfeed.ad.jp" "ntp3.jst.mfeed.ad.jp" ];
}
