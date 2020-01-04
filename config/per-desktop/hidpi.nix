{ config, ... }:
{
  services.xserver.dpi = 192;
  fonts.fontconfig.dpi = 192;

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTOSCREEN_SCALE_FACTOR = "0";
    QT_SCREEN_SCALE_FACTORS = "1.5";
    QT_SCALE_FACTOR = "1";
  };
}
