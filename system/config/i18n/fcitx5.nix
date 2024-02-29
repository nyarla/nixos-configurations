{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-cskk
      fcitx5-cskk-qt
      fcitx5-gtk
      libsForQt5.fcitx5-qt
    ];
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];
  environment.systemPackages = with pkgs; [ skk-dicts skktools ];
}
