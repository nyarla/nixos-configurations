{ config, pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-skk
      libsForQt5.fcitx5-qt
      ((libsForQt5.fcitx5-qt.override { inherit (qt6) qtbase; }).overrideAttrs
        (old: rec { cmakeFlags = old.cmakeFlags ++ [ "-DENABLE_QT6=1" ]; }))
    ];
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];
  environment.systemPackages = with pkgs; [ skk-dicts skktools ];
}
