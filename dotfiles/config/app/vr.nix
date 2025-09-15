{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    immersed
  ];

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config": [
        "${config.xdg.dataHome}/Steam/config"
      ],
      "external_drivers": null,
      "jsonid": "vrpathreg",
      "log": [
        "${config.xdg.dataHome}/Steam/logs"
      ],
      "runtime": [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version": 1
    }
  '';
}
