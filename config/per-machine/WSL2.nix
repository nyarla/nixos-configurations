{ config, pkgs, lib, ... }:
let
  defaultUser = "nyarla";
  syschdemd = import ../../external/WSL2/syschdemd.nix {
    inherit lib pkgs config defaultUser;
  };
  systemd-bootstrap = pkgs.stdenv.mkDerivation rec {
    name = "systemd-bootstrap-${version}";
    version = "2021-02-15";
    extraBootstrapConfig = ''
      ulimit -n 65535
    '';
    buildInputs = [ pkgs.gnused syschdemd ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin/
      cp ${syschdemd}/bin/syschdemd $out/bin/syschdemd
      extraConfig="$(echo '${extraBootstrapConfig}' | sed "s/\n/ ; /g")"
      sed -i "s!exec!''${extraConfig}; exec!" $out/bin/syschdemd
    '';
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
    shell = "${systemd-bootstrap}/bin/syschdemd";
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
