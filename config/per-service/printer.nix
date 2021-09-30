{ config, pkgs, ... }: {
  hardware.sane.enable = true;
  # networking.firewall.allowedUDPPorts = [ 8612 ];

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cnijfilter2 ];
}
