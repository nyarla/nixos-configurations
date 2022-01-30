{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs;
      [ (ibus-skk.override { layout = config.services.xserver.layout; }) ];
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];

  environment.systemPackages = with pkgs; [ skk-dicts skktools ];

  environment.variables = {
    "GTK_IM_MODULE" = "ibus";
    "QT_IM_MODULE" = "ibus";
    "XMODIFIERS" = "@im=ibus";
  };
}
