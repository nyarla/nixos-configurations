{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ skk ];
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];
  environment.systemPackages = with pkgs; [ skk-dicts skktools ];
}
