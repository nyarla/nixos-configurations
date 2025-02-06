{ config, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-cskk
      fcitx5-cskk-qt5
      fcitx5-cskk-qt6
      fcitx5-gtk
      fcitx5-skk
      kdePackages.fcitx5-qt
      kdePackages.fcitx5-skk-qt
      libsForQt5.fcitx5-qt
      libsForQt5.fcitx5-skk-qt
    ];
    fcitx5.waylandFrontend = true;
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];
  environment.systemPackages = with pkgs; [
    skktools
  ];
  environment.variables = {
    QT_IM_MODULE = "fcitx";
  };
}
