{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ xdg-utils ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    configPackages = with pkgs; [ xdg-desktop-portal-gtk ];

    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "HDMI-A-1";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
