{ config, pkgs, lib, ... }:
let
  defaultUser = "nyarla";
  syschdemd = import ../../external/WSL2/syschdemd.nix {
    inherit lib pkgs config defaultUser;
  };
in {
  boot.isContainer = true;
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  environment.noXlibs = false;
  environment.etc = {
    hosts.enable = false;
    "resolv.conf".enable = false;
  };

  networking.dhcpcd.enable = false;

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    extraGroups = [ "root" ];
  };

  security.wrapperDir = "/wrappers";
  security.sudo.wheelNeedsPassword = false;

  systemd.services = {
    "serial-getty@ttyS0".enable = false;
    "serial-getty@hvs0".enable = false;
    "getty@tty1".enable = false;
    "autovt@".enable = false;

    firewall.enable = false;
    systemd-resolved.enable = false;
    systemd-udevd.enable = false;
  };

  systemd.enableEmergencyMode = false;
}
