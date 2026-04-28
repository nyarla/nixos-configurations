{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    wayvr
    cage
    wivrn
  ];

  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.wivrn-stable}/share/openxr/1/openxr_wivrn.json";

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
    encoders = [
      {
        encoder = "vulkan";
        codec = "av1";
      }
    ];
    openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
  };
}
