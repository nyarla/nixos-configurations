{ config, pkgs, ... }:
{
  hardware.sane.enable = true;
  environment.etc = {
    "sane.d/pixma.conf" = {
      text = ''
        bjnp://192.168.1.23
      '';
    };
  };
  networking.firewall.allowedUDPPorts = [ 8612 ];

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    cups-bjnp
  ];
}
