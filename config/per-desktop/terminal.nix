{ config, pkgs, ... }:
let apps = with pkgs; [ mlterm fbterm ];
in {
  environment.systemPackages = apps;
  services.dbus.packages = apps;

  security.wrappers = {
    fbterm = {
      owner = "root";
      group = "wheel";
      source = "${pkgs.fbterm}/bin/fbterm";
      capabilities = "cap_sys_tty_config+ep";
    };
  };
}
