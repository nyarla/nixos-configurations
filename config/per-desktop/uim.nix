{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "uim";
    uim.toolbar = "gtk3-systray";
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];

  environment.systemPackages = with pkgs; [ skk-dicts skktools ];
}
