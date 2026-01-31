{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    immersed
    wayvr
    wivrn-stable
  ];

  xdg.configFile."openvr/openvrpaths.vrpath".text = builtins.toJSON {
    version = 1;
    config = [
      "${config.xdg.dataHome}/Steam/config"
    ];
    external_drivers = null;
    jsonid = "vrpathreg";
    log = [
      "${config.xdg.dataHome}/Steam/logs"
    ];
    runtime = [
      "${pkgs.xrizer}/lib/xrizer"
    ];
  };

  xdg.configFile."wivrn/config.json".text = builtins.toJSON {
    bitrate = 50000000;
    scale = 1;
    tcp-only = true;
    encoders = [
      {
        encoder = "vaapi";
        codec = "h265";
      }
    ];
    openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
  };
}
