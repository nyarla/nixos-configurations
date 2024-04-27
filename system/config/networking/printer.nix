{ pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cnijfilter2 ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [ sane-airscan ];
}
